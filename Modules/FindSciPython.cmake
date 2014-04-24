# - FindSciPython: Module to find include directories and
#   libraries for Python.
#
# Module usage:
#   find_package(SciPython ...)
#
# This module will define the following variables:
#  HAVE_PYTHON, PYTHON_FOUND = Whether libraries and includes are found
#  Python_INCLUDE_DIRS      = Location of Python includes
#  Python_LIBRARIES         = Required libraries

##################################################################
#
# Find module for Python
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
##################################################################

message(STATUS "Search for Python executable")
# Find in the path
if (WIN32)
  set(pynames python)
elseif ("${CMAKE_SYSTEM_NAME}" STREQUAL "Darwin" AND "${CMAKE_SYSTEM_VERSION}" STREQUAL "10.8.0")
  set(pynames python2.6)
  message(STATUS "Using Python 2.6 on SnowLeopard.")
else ()
  set(pynames python2.7 python2.6)
endif ()
find_program(Python_EXE NAMES ${pynames})
if (Python_EXE)

# Root directory, naes
  set(PYTHON_FOUND TRUE)
  get_filename_component(Python_EXE ${Python_EXE} REALPATH)
  get_filename_component(Python_NAME ${Python_EXE} NAME)
  string(REGEX REPLACE ".exe$" "" Python_NAME_WE "${Python_NAME}")
  get_filename_component(Python_BINDIR ${Python_EXE}/.. REALPATH)
  # SciPrintVar(Python_BINDIR)
  get_filename_component(Python_BINDIR_NAME ${Python_BINDIR} NAME)
  # SciPrintVar(Python_BINDIR_NAME)
  if ("${Python_BINDIR_NAME}" STREQUAL bin)
    get_filename_component(Python_ROOT_DIR ${Python_EXE}/../.. REALPATH)
  else ()
    get_filename_component(Python_ROOT_DIR ${Python_EXE}/.. REALPATH)
  endif ()
  SciPrintVar(Python_EXE)
  SciPrintVar(Python_NAME)
  SciPrintVar(Python_NAME_WE)

# Include directory
  execute_process(COMMAND ${Python_EXE} -c "import distutils.sysconfig; idir = distutils.sysconfig.get_python_inc(1); print idir,"
    OUTPUT_VARIABLE Python_INCLUDE_DIRS
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if (WIN32)
    file(TO_CMAKE_PATH "${Python_INCLUDE_DIRS}" Python_INCLUDE_DIRS)
  endif ()
  SciPrintVar(Python_INCLUDE_DIRS)

# Version
  execute_process(COMMAND ${Python_EXE} -c "import sys;print sys.version[0]"
    OUTPUT_VARIABLE Python_MAJOR
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  execute_process(COMMAND ${Python_EXE} -c "import sys;print sys.version[2]"
    OUTPUT_VARIABLE Python_MINOR
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  if (WIN32)
    set(Python_MAJMIN "${Python_MAJOR}${Python_MINOR}")
  else ()
    set(Python_MAJMIN "${Python_MAJOR}.${Python_MINOR}")
  endif ()
  SciPrintVar(Python_MAJMIN)
  set(Python_LIBRARY_NAME python${Python_MAJMIN})
  SciPrintVar(Python_LIBRARY_NAME)

# Library
  find_library(Python_LIBRARY ${Python_LIBRARY_NAME}
    PATHS ${Python_ROOT_DIR}
    PATH_SUFFIXES lib Libs
    NO_DEFAULT_PATH
  )
  if (Python_LIBRARY)
    get_filename_component(Python_LIBRARY ${Python_LIBRARY} REALPATH)
    SciPrintVar(Python_LIBRARY)
    set(Python_LIBRARIES ${Python_LIBRARY})
    SciPrintVar(Python_LIBRARIES)
    get_filename_component(Python_LIBRARY_DIRS ${Python_LIBRARY}/.. REALPATH)
    SciPrintVar(Python_LIBRARY_DIRS)
    if (WIN32)
      find_program(Python_DLLS ${Python_LIBRARY_NAME}.dll)
      SciPrintVar(Python_DLLS)
    endif ()
  else ()
    set(PYTHON_FOUND FALSE)
  endif ()

# Modules
  find_file(Python_SITE site.py
    PATHS ${Python_ROOT_DIR}
    PATH_SUFFIXES lib lib/${Python_NAME_WE}
    NO_DEFAULT_PATH
  )
  if (Python_SITE)
    get_filename_component(Python_MODULES_DIR ${Python_SITE}/.. REALPATH)
    SciPrintVar(Python_MODULES_DIR)
    file(RELATIVE_PATH Python_MODULES_SUBDIR ${Python_ROOT_DIR} ${Python_MODULES_DIR})
    SciPrintVar(Python_MODULES_SUBDIR)
  else ()
    set(PYTHON_FOUND FALSE)
  endif ()

else ()
  set(PYTHON_FOUND FALSE)
endif ()

if (PYTHON_FOUND)
  message(STATUS "[FindSciPython.cmake] - Found Python")
  set(HAVE_PYTHON 1 CACHE BOOL "Whether have Python.")
else ()
  message(STATUS "[FindSciPython.cmake] - Did not find Python, use -DPython_ROOT_DIR to supply the Python installation directory.")
  if (SciPython_FIND_REQUIRED)
    message(FATAL_ERROR "[FindSciPython.cmake] - Failing.")
  endif ()
endif ()

