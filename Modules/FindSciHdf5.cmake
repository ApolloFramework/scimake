# - FindSciHdf5: Module to find include directories and
#   libraries for Hdf5.
#
# Module usage:
#   find_package(SciHdf5 ...)
#
# This module will define the following variables:
#  HAVE_HDF5, HDF5_FOUND   = Whether libraries and includes are found
#  Hdf5_INCLUDE_DIRS       = Location of Hdf5 includes
#  Hdf5_LIBRARY_DIRS       = Location of Hdf5 libraries
#  Hdf5_LIBRARIES          = Required libraries
#  Hdf5_DLLS               =

######################################################################
#
# FindHdf5: find includes and libraries for hdf5
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

# The names of the hdf5 libraries can vary, so instead we find
# the includes and look for the cmake file.  But for that, we
# need the version.
message("")
message(STATUS "Initial search for Hdf5 components")
SciFindPackage(PACKAGE "Hdf5"
  HEADERS hdf5.h H5pubconf.h
  INCLUDE_SUBDIRS include include/hdf5/include # Last for VisIt installation
  FIND_QUIETLY
)

# The version is given by H5_PACKAGE_VERSION in H5pubconf.h
if (NOT Hdf5_H5pubconf_h)
  set(Hdf5_FOUND FALSE)
  message(FATAL_ERROR "Hfpubconf.h not found.")
endif ()
if (DEBUG_CMAKE)
  message(STATUS "Hdf5_H5pubconf_h = ${Hdf5_H5pubconf_h}.")
  message(STATUS "Hdf5_H5pubconf_h_INCLUDE_DIR = ${Hdf5_H5pubconf_h_INCLUDE_DIR}.")
endif ()
file(STRINGS ${Hdf5_H5pubconf_h} line
  REGEX "^#define *H5_PACKAGE_VERSION"
)
if (DEBUG_CMAKE)
  message(STATUS "line = ${line}.")
endif ()
string(REGEX REPLACE "#define *H5_PACKAGE_VERSION*" "" val "${line}")
string(REGEX REPLACE "\"" "" Hdf5_VERSION "${val}")
string(STRIP "${Hdf5_VERSION}" Hdf5_VERSION)
message(STATUS "Hdf5_VERSION = ${Hdf5_VERSION}.")

# Fill in what we know
get_filename_component(Hdf5_ROOT_DIR ${Hdf5_hdf5_h_INCLUDE_DIR}/.. REALPATH)
message(STATUS "Hdf5_ROOT_DIR = ${Hdf5_ROOT_DIR}.")

# Version known, can look for config file
SciFindPackage(PACKAGE "Hdf5"
  CONFIG_SUBDIRS
    lib/cmake/hdf5-${Hdf5_VERSION} # 1.8.6
    share/cmake/hdf5-${Hdf5_VERSION} # 1.8.7
  # USE_CONFIG_FILE # Cannot always source, so decide later
  CONFIG_FILE_ONLY
  FIND_QUIETLY
)
message(STATUS "Hdf5_CONFIG_CMAKE = ${Hdf5_CONFIG_CMAKE}.")

# If found, then fix up variables
if (NOT Hdf5_CONFIG_CMAKE)
  set(HDF5_FOUND FALSE)
  if (SciHdf5_FIND_REQUIRED)
    message(FATAL_ERROR "Failed to find Hdf5.")
  endif ()
endif ()

# Not all version have good files to source
if (${Hdf5_VERSION} STREQUAL 1.8.12)
else ()
  include(${Hdf5_CONFIG_CMAKE})
endif ()

# Get the libraries in proper order
if (HDF5_LIBRARIES)
  set(hlibs ${HDF5_LIBRARIES})
else ()
  file(GLOB hlibs ${Hdf5_ROOT_DIR}/lib/*hdf5*)
endif ()
# message(STATUS "hlibs = ${hlibs}.")
set(hlnms)
foreach (lb ${hlibs})
  get_filename_component(ln ${lb} NAME_WE)
# Remove leading lib
  string(REGEX REPLACE "^lib" "" ln "${ln}")
  set(hlnms ${hlnms} ${ln})
endforeach ()
# message(STATUS "hlnms = ${hlnms}.")
set(desiredlibs)
foreach (nm hdf5_tools hdf5_hl_fortran hdf5_hl_f90cstub hdf5_hl hdf5_hldll
  hdf5_fortran hdf5_f90cstub hdf5 hdf5dll
)
  list(FIND hlnms ${nm} indx)
  if (NOT(${indx} EQUAL -1))
    set(desiredlibs ${desiredlibs} ${nm})
  endif ()
endforeach ()
# message(STATUS "desiredlibs = ${desiredlibs}.")

# Get execs
file(GLOB hexecs ${Hdf5_ROOT_DIR}/bin/h5diff*)
set(desiredexecs)
foreach (ex ${hexecs})
  get_filename_component(en ${ex} NAME_WE)
  set(desiredexecs ${desiredexecs} ${en})
endforeach ()

if (DEBUG_CMAKE)
  message(STATUS "Looking for the HDF5 libraries, ${desiredlibs}.")
endif ()

set(desiredmods)
if (CMAKE_Fortran_COMPILER_WORKS)
  set(desiredmods hdf5)
endif ()
SciFindPackage(PACKAGE "Hdf5"
  PROGRAMS ${desiredexecs}
  HEADERS hdf5.h
  LIBRARIES ${desiredlibs}
  MODULES ${desiredmods}
  INCLUDE_SUBDIRS include include/hdf5/include # Last for VisIt installation
  MODULE_SUBDIRS include/fortran include lib
)

# The executables are not always found, so we will hdf5 to found
# if includes and libraries found.
if (NOT HDF5_FOUND)
  if (Hdf5_hdf5_h AND Hdf5_hdf5_LIBRARY AND Hdf5_hdf5_hl_LIBRARY)
    set(HDF5_FOUND TRUE)
    message(STATUS "Setting HDF5_FOUND to TRUE because header and libraries found.")
  endif ()
endif ()

if (HDF5_FOUND)
# Backward compatibility
  set(HAVE_HDF5 1 CACHE BOOL "Whether have the HDF5 library")
  set(OLD_H5S_SELECT_HYPERSLAB_IFC 0 CACHE BOOL
    "Whether using the old 1.6.3 H5Sselect_hyperslab interface")
  if (WIN32 AND Hdf5_DLLS)
    set(Hdf5_DEFINITIONS ${Hdf5_DEFINITIONS} -DH5_BUILT_AS_DYNAMIC_LIB)
    message(STATUS "Adding to Hdf5_DEFINITIONS that H5 build dynamic.")
    SciPrintVar(Hdf5_DEFINITIONS)
  endif ()
else ()
  message(STATUS "Did not find Hdf5.  Use -DHdf5_ROOT_DIR to specify the installation directory.")
  if (SciHdf5_FIND_REQUIRED)
    message(FATAL_ERROR "Failing.")
  endif ()
endif ()

