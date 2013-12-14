######################################################################
#
# SciFindPackage: find includes and libraries of a package
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################
#
# Variables which can be used to change the behavior of this script
#
# Where "scipkgreg" is the regularized package name
# (package name with all "." and "-" replaced with "_")
# Where "scipkguc" is the UPPERCASE regularized package name
#
#  DEBUG_CMAKE - if true, outputs verbose debugging information
#  (default false)
#
#  ENABLE_${scipkguc} - if false, will not search for package
#  (default true)
#  DISABLE_${scipkguc} - if true, sets ENABLE_${scipkguc} to false
#
#  ${scipkgreg}_FIND_QUIETLY - if true, will succeed silently
#  (default - not defined, which is treated as false)
#
#  ${scipkgreg}_FIND_REQUIRED - if true, will issue a fatal error if
#    package not found
#  (default - not defined, which is treated as false)
#
#  ${scipkgreg}_ROOT_DIR - search directory hints
#  ${scipkguc}_DIR, ${scipkgreg}_DIR: Deprecated search directory hints
#    (to be retired in July 2012)
#
#  SUPRA_SEARCH_PATH - used to specify various top-level search directories
#
######################################################################
#
#  Variables which will be defined by this script
#  In the event that a variable has no valid value, it will be set to
#   "${varname}-NOTFOUND"
#
#  NOTE: Some variables use scipkguc, and some use scipkgreg.
#    Caveat emptor.
#
#    ${scipkguc}_FOUND - true if package found
#
#  PROGRAMS:
#    ${scipkgreg}_PROGRAMS - list of found executables, including full
#      path to each.  Only defined for specifically requested executables.
#    ${scipkgreg}_yyy - full name & path to executable "yyy"
#      Only defined for specifically requested executables.
#
#  FILES:
#    ${scipkgreg}_FILES - list of found files, including a full path to each
#    ${scipkgreg}_yyy - full name and path to file "yyy"
#
#  MODULES:
#    ${scipkgreg}_MODULE_DIRS - a list of all module directories found
#    ${scipkgreg}_yyy_MOD - full path to individual module yyy.{mod,MOD}
#      Only defined for specifically requested modules
#
#  HEADERS:
#    ${scipkgreg}_INCLUDE_DIRS - a list of all include directories found
#    ${scipkgreg}_yyy - full path to individual header yyy
#      Only defined for specifically requested headers
#
#  LIBRARIES:
#    ${scipkgreg}_{library_name}_LIBRARY - full path to the individual
#      $library_name library. Only defined for specifically requested libraries.
#    ${scipkgreg}_LIBRARIES - list of found libraries, including full path to
#      each.  Only defined for specifically requested libraries.
#   ${scipkgreg}_STLIBS - list of all found static libraries.
#      Only defined for libraries existing in ${scipkgreg}_LIBRARIES
#   ${scipkgreg}_DLLS - windows only, list of all found dlls
#      Only defined for libraries existing in ${scipkgreg}_LIBRARIES
#
#######################################################################

# SciGetStaticLibs
#
# Given a list of libraries, create a new list, where for any
# dynamic library with a static library next to it, the new list
# contains the static library.  Otherwise it contains the original
# dynamic library.
#
# Args:
# origlibs: the original libraries
# statlibsvar: the variable holding the static libs when found
#
function(SciGetStaticLibs origlibs statlibsvar)
  # set(origlibs ${${origlibsvar}})
  set(statlibs)
  if (DEBUG_CMAKE)
    message(STATUS "[SciFindPackage]: original libs = ${origlibs}.")
    message(STATUS "[SciFindPackage]: statlibsvar = ${statlibsvar}.")
  endif ()
  foreach (lib ${origlibs})
    set(newlib ${lib})
    set(havestlib FALSE)
    if (${lib} MATCHES "\\.a$" OR ${lib} MATCHES "\\.lib$")
      if (DEBUG_CMAKE)
        message(STATUS "${lib} is a static library.")
      endif ()
      set(havestlib TRUE)
    endif ()
# If not static, try replacing suffix
    if (NOT ${havestlib})
      foreach (sfx so;dylib;dll)
        if (${lib} MATCHES "\\.${sfx}$")
          if (DEBUG_CMAKE)
            message(STATUS "${lib} is a shared library.")
          endif ()
          get_filename_component(libdir ${lib}/.. REALPATH)
# NAME_WE takes from first .  We generally need from last
          get_filename_component(libname "${lib}" NAME)
          string(REGEX REPLACE "\\.[^\\.]*$" "" libname "${libname}")
          if (${sfx} STREQUAL "dll")
            set(newsfx "lib")
          else ()
            set(newsfx "a")
          endif ()
          if (EXISTS ${libdir}/${libname}.${newsfx})
            set(newlib ${libdir}/${libname}.${newsfx})
            set(havestlib TRUE)
          endif ()
          break()
        endif ()
      endforeach ()
    endif ()
# If still do not have static, try pulling out of library flags
    if (${havestlib})
      list(APPEND statlibs ${newlib})
    elseif (${lib} MATCHES "^-L")
      if (DEBUG_CMAKE)
        message(STATUS "${lib} defined by flags.")
      endif ()
      # set(libargs ${lib}) # Create a list
      string(REPLACE " " ";" libargs "${lib}")
      if (DEBUG_CMAKE)
        message(STATUS "libargs = ${libargs}.")
      endif ()
      set(libdirargs)
      set(libdirs)
      set(libnames)
      foreach (libarg ${libargs})
        if (DEBUG_CMAKE)
          message(STATUS "libarg = ${libarg}.")
        endif ()
        if (${libarg} MATCHES "^-L")
          list(APPEND libdirargs ${libarg})
          string(REGEX REPLACE "^-L" "" libdir ${libarg})
          list(APPEND libdirs ${libdir})
        elseif (${libarg} MATCHES "^-l")
          string(REGEX REPLACE "^-l" "" libname ${libarg})
          list(APPEND libnames ${libname})
        endif ()
      endforeach ()
      if (DEBUG_CMAKE)
        message(STATUS "libdirs = ${libdirs}.")
        message(STATUS "libnames = ${libnames}.")
      endif ()
      set(stlibs)
      foreach (libname ${libnames})
        set(lib)
        foreach (libdir ${libdirs})
          if (EXISTS ${libdir}/lib${libname}.a)
            set(lib ${libdir}/lib${libname}.a)
            break()
          elseif (EXISTS ${libdir}/${libname}.lib)
            set(lib ${libdir}/${libname}.lib)
            break()
          endif ()
        endforeach ()
        if (lib)
          list(APPEND stlibs ${lib})
        else ()
          list(APPEND stlibs "${libdirargs} -l${libname}")
        endif ()
      endforeach ()
      list(APPEND statlibs ${stlibs})
    else ()
# If still not static, look in system dirs
      foreach (libdir /usr/lib64;/usr/lib)
        if (EXISTS ${libdir}/lib${lib}.a)
          set(newlib ${libdir}/lib${lib}.a)
          set(havestlib TRUE)
          break()
        endif ()
      endforeach ()
      list(APPEND statlibs ${newlib})
    endif ()
  endforeach ()
  if (DEBUG_CMAKE)
    message(STATUS "[SciFindPackage]: static libs = ${statlibs}.")
  endif ()
  set(${statlibsvar} ${statlibs} PARENT_SCOPE)
endfunction()

# SciGetRealDir
#
# Given a directory name, find the real directory name after
#  first trying to resolve it as a shortcut if on Windows,
#  then, if that does not work, trying to resolve it as a soft
#  link.
#
# Args:
#  canddir: the variable holding the directory candidate
#  realdirvar: the variable holding the directory after following any shortcuts
#
function(SciGetRealDir canddir realdirvar)

  # MESSAGE("realdirvar = ${realdirvar}.")
  set(${realdirvar})
  if (canddir)
    if (DEBUG_CMAKE)
      message(STATUS "Finding the directory for ${canddir}.")
    endif ()
# Follow an existing Windows shortcut
    if (WIN32)
      if (EXISTS ${canddir}.lnk)
        exec_program(readshortcut ARGS ${canddir}.lnk
          OUTPUT_VARIABLE idir
          return_VALUE ires)
        if (ires)
          message(FATAL_ERROR "readshortcut error on ${canddir}.lnk.")
        endif ()
        exec_program(cygpath ARGS -am ${idir} OUTPUT_VARIABLE rd)
      else ()
        set(rd ${canddir})
      endif ()
    else ()
       get_filename_component(rd ${canddir} REALPATH)
    endif ()
  endif ()
  set(${realdirvar} ${rd} PARENT_SCOPE)
endfunction()

# SciGetInstSubdirs
#
# Given a package name, set the possible installation subdirs
#
# Args:
#  pkgnamelc: the variable holding the package name in lower case
#  instdirsvar: the variable holding possible installation directories
#
function(SciGetInstSubdirs pkgnamelc instdirsvar)
  # message(STATUS "SciGetInstSubdirs called with pkgname = ${pkgname} and instdirsvar = ${instdirsvar}.")
  if (ENABLE_PARALLEL)
    if (USE_SHARED_LIBS)
      set(instdirs ${pkgnamelc}-parsh)
    else ()
      set(instdirs ${pkgnamelc}-par ${pkgnamelc}-ben)
    endif ()
  else ()
    if (USE_CC4PY_LIBS)
      set(instdirs ${pkgnamelc}-cc4py ${pkgnamelc}-sersh)
      if (WIN32)
        set(instdirs ${instdirs} ${pkgnamelc}-sermd)
      else ()
        set(instdirs ${instdirs} ${pkgnamelc})
      endif ()
    elseif (USE_SHARED_LIBS)
      set(instdirs ${pkgnamelc}-sersh)
      if (WIN32)
        set(instdirs ${instdirs} ${pkgnamelc}-sermd)
      else ()
        set(instdirs ${instdirs} ${pkgnamelc})
      endif ()
    elseif (BUILD_WITH_SHARED_RUNTIME)
      set(instdirs ${pkgnamelc}-sermd ${pkgnamelc})
    else ()
      set(instdirs ${pkgnamelc})
    endif ()
  endif ()
  # message(STATUS "SciGetInstSubdirs finds instdirs = ${instdirs}.")
  set(${instdirsvar} ${instdirs} PARENT_SCOPE)
endfunction()

# SciGetRootPath
#
# Construct a path, collection of directories, that one is to search
# to find the root dir.
#
# Args:
#  pkgname: the variable holding the package name with regular capitalization
#  instsubdirs: possible installation subdirs
#  rootpathvar: on output, holds possible installation directories
#
function(SciGetRootPath pkgname instsubdirs rootpathvar)

# Get the installation subdirs
  # string(TOLOWER ${pkgname} pkgnamelc)
  # SciGetInstSubdirs(${pkgnamelc} instsubdirs)
  if (DEBUG_CMAKE)
    message(STATUS "SciGetRootPath: instsubdirs = ${instsubdirs}.")
  endif ()
  string(TOUPPER ${pkgname} pkgnameuc)

# Find the possible directories and put them into path
# Order: command-line define, environment variable, supra-search-path subdirs,
# supra-search-path dirs
  if (DEBUG_CMAKE)
    message(STATUS "${pkgname}_ROOT_DIR = ${${pkgname}_ROOT_DIR}.")
    message("[SciFindPackage] SUPRA_SEARCH_PATH = ${SUPRA_SEARCH_PATH}")
  endif ()
  set(rootpath)

# Command-line define overrides all.
  if (${pkgname}_ROOT_DIR)
    SciGetRealDir(${${pkgname}_ROOT_DIR} rootpath)
  else ()
    if (${pkgname}_DIR)
# JRC 20120617: Remove this July 31, 2012.
      message(STATUS "${pkgname}_DIR = ${${pkgname}_DIR}.")
      message(FATAL_ERROR "Use of ${pkgname}_DIR define is removed.  Please use ${pkgname}_ROOT_DIR")
      # SciGetRealDir(${${pkgname}_DIR} rootpath)
    endif ()
# The deprecated variable name is commonly ${scipkguc}_DIR
# MD 20120619: Remove this July 31, 2012.
    if (${pkgnameuc}_DIR)
      message(STATUS "${pkgnameuc}_DIR = ${${pkgnameuc}_DIR}.")
      message(FATAL_ERROR "Use of ${pkgnameuc}_DIR define is removed.  Please use ${pkgname}_ROOT_DIR")
      # SciGetRealDir(${${pkgnameuc}_DIR} rootpath)
    endif ()
  endif ()
  if (DEBUG_CMAKE)
    message(STATUS "${pkgname}_ROOT_DIR = ${${pkgname}_ROOT_DIR}.")
  endif ()

# Next try environment variable.  Should this be appended regardless?
  if (NOT DEFINED ${rootpath})
    if ($ENV{${pkgname}_ROOT_DIR})
      SciGetRealDir($ENV{${pkgname}_ROOT_DIR} rootpath)
    else ()
      if ($ENV{${pkgname}_DIR})
# JRC 20120617: Remove this July 31, 2012.
        message(FATAL_ERROR "Use of ${pkgname}_DIR environment variable is removed .  Please use ${pkgname}_ROOT_DIR")
        # SciGetRealDir($ENV{${pkgname}_DIR} rootpath)
      endif ()
      if ($ENV{${pkgnameuc}_DIR})
# MD 20120619: Remove this July 31, 2012.
        message(WARNING "Use of ${pkgnameuc}_DIR environment variable is removed.  Please use ${pkgname}_ROOT_DIR")
        # SciGetRealDir($ENV{${pkgnameuc}_DIR} rootpath)
      endif ()
    endif ()
  endif ()
  if (DEBUG_CMAKE)
    message(STATUS "After looking for ${pkgname}_ROOT_DIR in the environment, rootpath = ${rootpath}.")
  endif ()

# Supra-search-path dirs
  foreach (instdir ${instsubdirs})
    foreach (spdir ${SUPRA_SEARCH_PATH})
      set(idir ${spdir}/${instdir})
      if (EXISTS ${idir})
        SciGetRealDir(${idir} scidir)
        set(rootpath ${rootpath} ${scidir})
      endif ()
    endforeach (spdir ${SUPRA_SEARCH_PATH})
  endforeach ()

# Supra-search-path dirs
  foreach (spdir ${SUPRA_SEARCH_PATH})
    set(idir ${spdir})
    if (EXISTS ${idir})
      SciGetRealDir(${idir} scidir)
      set(rootpath ${rootpath} ${scidir})
    endif ()
  endforeach (spdir ${SUPRA_SEARCH_PATH})

# Any found?
  list(LENGTH rootpath rootpathlen)
  if (DEBUG_CMAKE)
    if (rootpathlen)
      list(REMOVE_DUPLICATES rootpath)
      message(STATUS "rootpath = ${rootpath}")
    else ()
      message(FATAL_ERROR "rootpath is empty.")
    endif ()
  endif ()

# Return value
  set(${rootpathvar} ${rootpath} PARENT_SCOPE)
endfunction()

# SciFindPkgFiles
#
# Find the files of a type for a package.
#
# Args:
#  pkgname: the variable holding the package name with regular capitalization
#  pkgfiles: the files to search for
#  rootpath: contains possible installation root directories
#  filesubdirs: possible file subdirs
#  singularsfx: singular version of the file type
#  pluralsfx: plural version of the file type
#  allfoundvar: whether all files were found
#  allowdups: whether duplicates are allowed in list
#
function(SciFindPkgFiles pkgname pkgfiles
  rootpath filesubdirs
  singularsfx pluralsfx allfoundvar)

  if (DEBUG_CMAKE)
    message(STATUS "Looking for files of type, ${singularsfx} under ${rootpath} with filesubdirs = ${filesubdirs}.")
  endif ()

# Set the package path

# Loop over list of executables and try to find each one
  set(abspkgfiles)
  set(pkgdirs)
  set(allfound TRUE)
  foreach (pkgfile ${pkgfiles})

# Create the variable that's specific to this executable
    string(REGEX REPLACE "[./-]" "_" pkgfilevar ${pkgfile})
    set(pkgfilevar ${pkgname}_${pkgfilevar})
    if (${singularsfx} STREQUAL LIBRARY)
      set(pkgfilevar ${pkgfilevar}_LIBRARY)
    endif ()
    if (DEBUG_CMAKE)
      message(STATUS "Searching for pkgfile = ${pkgfile}.")
    endif ()

# First look in specified path
    set(basesrchargs ${pkgfilevar} ${pkgfile}
    )
    set(fullsrchargs "${basesrchargs}"
      PATHS "${rootpath}"
      PATH_SUFFIXES "${filesubdirs}"
      NO_DEFAULT_PATH
    )
    if (DEBUG_CMAKE)
      message(STATUS "fullsrchargs = ${fullsrchargs}.")
    endif ()
    if (${singularsfx} STREQUAL PROGRAM)
      find_program(${fullsrchargs}
        DOC "Path to the ${pkgfile} ${singularsfx}"
      )
    elseif (${singularsfx} STREQUAL LIBRARY)
      find_library(${fullsrchargs}
        DOC "Path to the ${pkgfile} ${singularsfx}"
      )
    else ()
      find_file(${fullsrchargs}
        DOC "Path to the ${pkgfile} ${singularsfx}"
      )
    endif ()
    if (DEBUG_CMAKE)
      message(STATUS "From first search: ${pkgfilevar} = ${${pkgfilevar}}.")
    endif ()

# If not found, try again with default paths
    if (NOT ${pkgfilevar})
      if (DEBUG_CMAKE)
        message(STATUS "Failed to find ${pkgfile} in search path, trying default paths.")
      endif ()
      if (${singularsfx} STREQUAL PROGRAM)
        find_program(${basesrchargs}
          DOC "Path to the ${pkgfile} ${singularsfx}"
        )
      elseif (${singularsfx} STREQUAL LIBRARY)
        find_library(${basesrchargs}
          DOC "Path to the ${pkgfile} ${singularsfx}"
        )
      else ()
        find_file(${basesrchargs}
          DOC "Path to the ${pkgfile} ${singularsfx}"
        )
      endif ()
      if (DEBUG_CMAKE)
        message(STATUS "From second search: ${pkgfilevar} = ${${pkgfilevar}}.")
      endif ()
    endif ()

    if (${pkgfilevar})
# Add to list of all files of this type for this package
      set(abspkgfiles ${abspkgfiles} ${${pkgfilevar}})
      get_filename_component(pkgfiledir ${${pkgfilevar}}/.. REALPATH)
      set(pkgdirs ${pkgdirs} ${pkgfiledir})
    else ()
# The WARNING option will actually give a scimake stack trace.
# Not wanted, so use NO option, and start the string with WARNING
      message("WARNING - Unable to locate file, ${pkgfile}.")
      set(allfound FALSE)
    endif ()
  endforeach ()

# Clean up the lists of files and directories
  list(LENGTH abspkgfiles numpkgfiles)
  if (${numpkgfiles})
    if (NOT ${ALLOWDUPS})
      list(REMOVE_DUPLICATES abspkgfiles)
    endif ()
    list(REMOVE_DUPLICATES pkgdirs)
  endif ()

# Print results if in debug mode
  if (DEBUG_CMAKE)
    message(STATUS "Setting:")
    message(STATUS "  ${pkgname}_${pluralsfx} = ${abspkgfiles}.")
    message(STATUS "  ${pkgname}_${singularsfx}_DIRS = ${pkgdirs}.")
  endif ()

# Set the return vars
  set(${pkgname}_${pluralsfx} ${abspkgfiles}
    CACHE STRING "List of all files of type, ${singularsfx}, for ${pkgname}"
  )
  set(${pkgname}_${singularsfx}_DIRS ${pkgdirs}
    CACHE STRING "List of all directories for files of type, ${singularsfx}, for ${pkgname}"
  )
  set(${pkgname}_${pluralsfx} ${abspkgfiles} PARENT_SCOPE)
  set(${pkgname}_${singularsfx}_DIRS ${pkgdirs} PARENT_SCOPE)
  set(${allfoundvar} ${allfound} PARENT_SCOPE)

endfunction()

#
# SciFindPackage
#
# Args:
# NOPRINT: Do not print the results
# PACKAGE: the prefix for the defined variables
# INSTALL_DIRS: the names for the installation subdirectory.  Defaults
#   to lower cased scipkgname
# PROGRAMS: the executables to look for
# HEADERS: the header files to look for.
# LIBRARIES: the libraries
# FILES: other files to look for
# MODULES: Fortran module files
# PROGRAM_SUBDIRS: executable subdirs
# INCLUDE_SUBDIRS: include subdirectories
# LIBRARY_SUBDIRS: library subdirectories
# FILE_SUBDIRS: file subdirectories
#
# NOTE: One cannot reset calling variables
# NOTE: lists should be delimited by semicolons.
#(which is the default format used by scimake)
#

include(CMakeParseArguments)
macro(SciFindPackage)
  CMAKE_PARSE_ARGUMENTS(TFP
    "FIND_QUIETLY;USE_CONFIG_FILE"
    "PACKAGE;INSTALL_DIR"
    "INSTALL_DIRS;PROGRAMS;HEADERS;LIBRARIES;FILES;MODULES;PROGRAM_SUBDIRS;INCLUDE_SUBDIRS;MODULE_SUBDIRS;LIBRARY_SUBDIRS;FILE_SUBDIRS;ALLOW_LIBRARY_DUPLICATES"
    ${ARGN}
  )

# This message is purposefully NOT a STATUS message
# To provide more readable output
  if (NOT DEBUG_CMAKE AND TFP_FIND_QUIETLY)
    message(STATUS "Looking for ${TFP_PACKAGE}.")
  else ()
    message("")
    message("--------- SciFindPackage looking for ${TFP_PACKAGE} ---------")
  endif ()

  if (DEBUG_CMAKE)
    message(STATUS "Outputting debug information.")
    message(STATUS "${TFP_PACKAGE}_ROOT_DIR=${${TFP_PACKAGE}_ROOT_DIR}")
    message(STATUS "SciFindPackage called with arguments:
      PACKAGE         = ${TFP_PACKAGE}
      INSTALL_DIR     = ${TFP_INSTALL_DIR}
      INSTALL_DIRS    = ${TFP_INSTALL_DIRS}
      PROGRAMS        = ${TFP_PROGRAMS}
      HEADERS         = ${TFP_HEADERS}
      LIBRARIES       = ${TFP_LIBRARIES}
      MODULES         = ${TFP_MODULES}
      PROGRAM_SUBDIRS = ${TFP_PROGRAM_SUBDIRS}
      INCLUDE_SUBDIRS = ${TFP_INCLUDE_SUBDIRS}
      LIBRARY_SUBDIRS = ${TFP_LIBRARY_SUBDIRS}
      FILE_SUBDIRS    = ${TFP_FILE_SUBDIRS}
      ALLOW_LIBRARY_DUPLICATES = ${TFP_ALLOW_LIBRARY_DUPLICATES}
      USE_CONFIG_FILE = ${TFP_USE_CONFIG_FILE}"
    )
  endif ()

  if(${TFP_PACKAGE}_FOUND)
    if(DEBUG_CMAKE)
      message(STATUS "Already found this package, skipping...")
    endif()
  endif()

# Construct various names(upper/lower case) for package
  string(REGEX REPLACE "[./-]" "_" scipkgreg ${TFP_PACKAGE})
# scipkgreg is the regularized package name
  string(TOUPPER ${scipkgreg} scipkguc)
  if (DEBUG_CMAKE)
    message(STATUS "ENABLE_${scipkguc} = ${ENABLE_${scipkguc}}")
  endif ()
  if (DISABLE_${scipkguc})
    set(ENABLE_${scipkguc} FALSE)
  endif ()
  if (NOT DEFINED ENABLE_${scipkguc})
    set(ENABLE_${scipkguc} TRUE)
  endif ()
  if (NOT ENABLE_${scipkguc})
    message(STATUS "Disabling ${scipkgreg}.")
    set(${scipkguc}_FOUND FALSE)
    if (DEBUG_CMAKE)
      message(STATUS "${scipkguc}_FOUND set to FALSE.")
    endif ()
    return()
  endif ()
# Set to true until not something not found
  set(${scipkguc}_FOUND TRUE)
  string(TOLOWER ${scipkgreg} scipkglc)
  set(scipkginst ${TFP_INSTALL_DIR} ${TFP_INSTALL_DIRS})
  if (NOT scipkginst)
    SciGetInstSubdirs(${scipkglc} scipkginst)
  endif ()
  if (DEBUG_CMAKE)
    message(STATUS "scipkginst = ${scipkginst}.")
  endif ()

# Find the set of possible root installation dirs
  SciGetRootPath(${scipkgreg} "${scipkginst}" scipath)
  if (DEBUG_CMAKE)
    message(STATUS "scipath = ${scipath}")
  endif ()

#######################################################################
#
# Look for cmake configuration files
# Variables defined:
#   Xxx_CONFIG_FILE: path to the PkgConfig.cmake
#   Xxx_CONFIG_VERSION_FILE: path to the PkgConfigVersion.cmake
#
#######################################################################

  if (TFP_USE_CONFIG_FILE)

# Get the config file
    set(sciconfigcmvar "${scipkgreg}_CONFIG_CMAKE")
    message(STATUS "Looking for ${scipkgreg}Config.cmake, ${scipkglc}-config.cmake.")
    find_file(${sciconfigcmvar}
      NAMES ${scipkgreg}Config.cmake ${scipkglc}-config.cmake
      PATHS ${scipath}
      PATH_SUFFIXES lib/cmake/${scipkgreg} share/cmake/${scipkglc}
      NO_DEFAULT_PATH
      DOC "Path to the hdf5 config files."
    )

# If not found, look in system directories
    if (NOT ${scipkgreg}_CONFIG_CMAKE)
      find_file(${scipkgreg}_CONFIG_CMAKE
        NAMES ${scipkgreg}Config.cmake ${scipkglc}-config.cmake
      )
    endif ()

# If found, source
    if (${scipkgreg}_CONFIG_CMAKE)
      get_filename_component(${scipkgreg}_CONFIG_DIR ${${scipkgreg}_CONFIG_CMAKE}/.. REALPATH)
      find_file(${scipkgreg}_CONFIG_VERSION_CMAKE
        NAMES ${scipkgreg}ConfigVersion.cmake ${scipkgreg}-config-version.cmake
        PATHS ${${scipkgreg}_CONFIG_DIR}
      )
      include(${${scipkgreg}_CONFIG_CMAKE})
    endif ()

  endif ()

#######################################################################
#
# Look for TYPES = PROGRAMS, FILES, MODULES
# Variables defined:
#   For PROGRAMS, FILES, MODULES
#     Xxx_yyy - CACHED
#       Where to find the yyy file that comes with Xxx.
#   Xxx_${TYPE} - CACHED
#     List of all files of that type found for package Xxx.
#
#######################################################################

# Create the search paths
  foreach (scitype PROGRAM INCLUDE MODULE LIBRARY FILE)

# Get plural
    if (${scitype} STREQUAL LIBRARY)
      set(scitypeplural LIBRARIES)
    elseif (${scitype} STREQUAL INCLUDE)
      set(scitypeplural HEADERS)
    else ()
      set(scitypeplural ${scitype}S)
    endif ()

# Get length of list
    # if (${scitype} STREQUAL INCLUDE)
      # set(srchfilesvar TFP_HEADERS)
    # else ()
      set(srchfilesvar TFP_${scitypeplural})
    # endif ()
    list(LENGTH ${srchfilesvar} sciexecslen)
    if (${sciexecslen})

# Create lists for search
      list(LENGTH TFP_${scitype}_SUBDIRS scilen)
      if (${scilen})
        set(scifilesubdirs ${TFP_${scitype}_SUBDIRS})
      else ()
# Default search subdirectories
        if (${scitype} STREQUAL PROGRAM)
          set(scifilesubdirs bin)
        elseif (${scitype} STREQUAL FILE)
          set(scifilesubdirs share)
        elseif (${scitype} STREQUAL INCLUDE)
          set(scifilesubdirs include)
        elseif (${scitype} STREQUAL LIBRARY)
          set(scifilesubdirs lib)
        else ()
          message(WARNING "Default subdir not known for ${scitype}.")
        endif ()
      endif ()
      message(STATUS "Looking for ${${srchfilesvar}} in ${scifilesubdirs}.")

# Find the files
      SciFindPkgFiles(${scipkgreg} "${${srchfilesvar}}"
        "${scipath}" "${scifilesubdirs}"
        ${scitype} ${scitypeplural} ${scipkgreg}_${scitypeplural}_FOUND
        ${TFP_ALLOW_LIBRARY_DUPLICATES}
      )
    endif ()

  endforeach ()

if (FALSE)
###########################################################################
#
# Look for LIBRARIES
# Finding none is fatal, but finding a subset is okay as allows us
# to look for a maximum set, as needed for Trilinos.
# XXX_LIBRARIES - NOT CACHED
#   The libraries to link against to use XXX. These should include full paths.
# XXX_YY_LIBRARY -
#   Name of YY library that is part of the XXX system.
#
###########################################################################

# Build list of search directories
  string(LENGTH TFP_LIBRARIES scilibslen)
  if (${scilibslen})
# Add in user-supplied subdirs
    string(LENGTH "${TFP_LIBRARY_SUBDIRS}" scilen)
    if (${scilen})
      set(scilibsubdirs ${TFP_LIBRARY_SUBDIRS})
    else ()
# Default subdirectory
      set(scilibsubdirs lib)
    endif ()

# Does anyone use this?  Should either move to argument list
# or remove entirely.  TODO - marc
# If LIBRARY_DIRS specified, add that to the front of the path
    if (${scipkgreg}_LIBRARY_DIRS)
      set(scilibsubdirs . ${scilibsubdirs})
      set(scipath ${${scipkgreg}_LIBRARY_DIRS} ${scipath})
    endif ()

    if (DEBUG_CMAKE)
      message(STATUS "Looking for libraries under ${scipath} with subdirs, ${scilibsubdirs}")
    endif ()

# Clear variables
    set(${scipkgreg}_LIBRARIES)
    set(${scipkgreg}_LIBRARY_DIRS)
    set(${scipkgreg}_LIBRARY_NAMES)
    set(${scipkgreg}_FOUND_SOME_LIBRARY FALSE)

# Look for each requested library
    foreach (scilib ${TFP_LIBRARIES})
# Build variable name of the form XXX_yyy_LIBRARY
      string(REGEX REPLACE "[./-]" "_" scilibvar ${scilib})
      set(scilibdirvar ${scipkgreg}_${scilibvar}_LIBRARY_DIR)
      unset(${scilibdirvar})
      set(scilibvar ${scipkgreg}_${scilibvar}_LIBRARY)
      unset(${scilibvar})

# First look in defined paths
      find_library(${scilibvar}
        ${scilib}
        PATHS ${scipath}
        PATH_SUFFIXES ${scilibsubdirs}
        NO_DEFAULT_PATH
      )
      if (DEBUG_CMAKE)
        message(STATUS "After initial search, ${scilibvar} = ${${scilibvar}}.")
      endif ()

# If not found, try again in default paths
      if (NOT ${scilibvar})
        find_library(${scilibvar}
          ${scilib}
          PATHS ${scipath}
          PATH_SUFFIXES ${scilibsubdirs}
        )
        if (DEBUG_CMAKE)
          message(STATUS "After second search, ${scilibvar} = ${${scilibvar}}.")
        endif ()
      endif ()

# Add to list of all libraries(if found)
      if (${scilibvar})
        if (DEBUG_CMAKE)
          message(STATUS "Found library ${scilib}: ${scilibvar} = ${${scilibvar}}")
        endif ()
        set(${scipkgreg}_FOUND_SOME_LIBRARY TRUE)
        set(${scipkgreg}_LIBRARIES
            ${${scipkgreg}_LIBRARIES}
            ${${scilibvar}}
        )
        get_filename_component(${scilibdirvar} ${${scilibvar}}/.. REALPATH)
        if (DEBUG_CMAKE)
          message(STATUS "${scilibdirvar} = ${${scilibdirvar}}")
        endif ()
        list(APPEND ${scipkgreg}_LIBRARY_DIRS ${${scilibdirvar}})
# NAME_WE removes from first '.'.  We need from last.
        get_filename_component(libname ${${scilibvar}} NAME)
        string(REGEX REPLACE "\\.[^\\.]*$" "" libname "${libname}")
        string(REGEX REPLACE "^lib" "" libname ${libname})
        list(APPEND ${scipkgreg}_LIBRARY_NAMES ${libname})
      else ()
# Yes, this uses the string WARNING instead of the macro argument WARNING
        message("WARNING - Library ${scilib} not found.")
        set(${scipkguc}_FOUND FALSE)
      endif ()
# Add both to the cache
      # set(${scilibvar}
        # ${${scilibvar}}
        # CACHE FILEPATH "Location of ${scilib}"
      # )
      set(${scilibdirvar}
        ${${scilibdirvar}}
        CACHE PATH "Directory of ${scilib}"
      )
    endforeach (scilib ${TFP_LIBRARIES})
    if (DEBUG_CMAKE)
      message(STATUS "${scipkgreg}_LIBRARY_DIRS = ${${scipkgreg}_LIBRARY_DIRS}")
    endif ()

# Clean up and commit variables to cache
    list(LENGTH ${scipkgreg}_LIBRARIES sciliblistlen)
    if (TFP_LIBRARIES AND NOT ${sciliblistlen})
      message("WARNING - None of the libraries, ${TFP_LIBRARIES}, found.  Define ${scipkgreg}_ROOT_DIR to find them.")
    elseif (${sciliblistlen})
      # Allowing duplicate libraries on the link line is necessary when using the magma library - Jon Rood
      if(NOT TFP_ALLOW_LIBRARY_DUPLICATES)
        list(REMOVE_DUPLICATES ${scipkgreg}_LIBRARIES)
      endif ()
      list(REMOVE_DUPLICATES ${scipkgreg}_LIBRARY_DIRS)
# The first dir is the library dir
      list(GET "${scipkgreg}_LIBRARY_DIRS" 0 ${scipkgreg}_LIBRARY_DIR)
#      if (NOT DEFINED ${scipkgreg}_DIR)
#        get_filename_component(${scipkgreg}_DIR ${${scipkgreg}_LIBRARY_DIR}/.. REALPATH)
#      endif ()
      if (DEBUG_CMAKE)
        message(STATUS "${scipkgreg}_DIR = ${${scipkgreg}_DIR}")
        message(STATUS "${scipkgreg}_LIBRARIES = ${${scipkgreg}_LIBRARIES}")
        message(STATUS "${scipkgreg}_LIBRARY_DIRS = ${${scipkgreg}_LIBRARY_DIRS}")
      endif ()
    endif ()

  endif ()
endif ()

# Find static libraries
  if (${scipkgreg}_LIBRARIES)
    SciGetStaticLibs("${${scipkgreg}_LIBRARIES}" ${scipkgreg}_STLIBS)
  endif ()

#################################################################
#
# On windows, we want to look for the dlls
# XXX_DLLS - CACHED
#   List of all found dlls including full path to each
# XXX_yyy_dll
#   Path to individual yyy library from XXX package
#
#################################################################

  if (WIN32)
    if (DEBUG_CMAKE)
      message(STATUS "Looking for the DLL counterparts to all found libraries.")
    endif ()

# Clear variables
    set(${scipkgreg}_DLLS)
    set(${scipkgreg}_FOUND_SOME_DLL FALSE)

# Look for a dll for each found library
    foreach (foundlib ${${scipkgreg}_LIBRARIES})
# NAME_WE removes from first '.'.  We need from last.
      get_filename_component(librootname ${foundlib} NAME)
      string(REGEX REPLACE "\\.[^\\.]*$" "" librootname "${librootname}")
# Get variable to hold the dll location
      string(REGEX REPLACE "[./-]" "_" scidllvar ${librootname})
      set(scidllvar ${scipkgreg}_${scidllvar}_dll)
      set(${scidllvar})
# This assumes that dll is in "./lib/../bin"
      get_filename_component(libdir ${foundlib}/.. REALPATH)
      get_filename_component(dlldir1 "${libdir}/../bin" REALPATH)
      get_filename_component(dlldir2 "${libdir}/.." REALPATH)
      foreach (dir ${dlldir1} ${dlldir2} ${libdir})
        if (DEBUG_CMAKE)
          message(STATUS "Looking for DLL for ${foundlib} in ${dir}.")
        endif ()
        if (EXISTS ${dir}/${librootname}.dll)
          set(${scidllvar} ${dir}/${librootname}.dll)
          break ()
        endif ()
      endforeach ()
      if (${scidllvar})
        if (DEBUG_CMAKE)
          message(STATUS "Found DLL ${${scidllvar}}")
          message(STATUS "${scidllvar} = ${${scidllvar}}.")
        endif ()
        set(${scipkgreg}_DLLS ${${scipkgreg}_DLLS} ${${scidllvar}})
        set(${scipkgreg}_FOUND_SOME_DLL TRUE)
        set(${scidllvar}
          ${${scidllvar}}
          CACHE PATH "Path to ${librootname}.dll"
        )
      else ()
        if (DEBUG_CMAKE)
          message(STATUS "${librootname}.dll not found.")
        endif ()
      endif ()
    endforeach ()
  endif ()
  if (${scipkgreg}_FOUND_SOME_DLL)
    set(${scipkgreg}_DEFINITIONS -D${scipkguc}_DLL)
  endif ()

####################################################################
#
# For the package to be marked as found, all requested objects must
# have been found, as coded above.
# Per http://www.cmake.org/Wiki/scimake:How_To_Find_Installed_Software,
# The convention is to capitalize the _FOUND variable.
#
####################################################################

  if (DEBUG_CMAKE OR NOT TFP_FIND_QUIETLY)
    SciPrintCMakeResults(${scipkgreg})
  endif ()

# If this was marked as a required package, fail
  if (${scipkgreg}_FIND_REQUIRED AND NOT ${scipkguc}_FOUND)
    message(FATAL_ERROR "Unable to find required package ${scipkgreg} - failing")
  endif ()

  if (DEBUG_CMAKE OR NOT TFP_FIND_QUIETLY)
    message(STATUS "${scipkguc}_FOUND = ${${scipkguc}_FOUND}.")
    message("--------- SciFindPackage done with ${TFP_PACKAGE} -----------")
  endif ()

endmacro(SciFindPackage)

