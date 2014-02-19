# - FindSciPython: Module to find include directories and
#   libraries for Python.
#
# Module usage:
#   find_package(SciPython ...)
#
# This module will define the following variables:
#  HAVE_PYTHON, PYTHON_FOUND = Whether libraries and includes are found
#  Python_INCLUDE_DIRS      = Location of Python includes
#  Python_LIBRARY_DIRS      = Location of Python libraries
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
find_program(Python_EXE NAMES python2.7 python2.6 python)
if (Python_EXE)
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
  execute_process(COMMAND ${Python_EXE} -c "import distutils.sysconfig; idir = distutils.sysconfig.get_python_inc(1); print idir,"
    OUTPUT_VARIABLE Python_INCLUDE_DIRS
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  SciPrintVar(Python_INCLUDE_DIRS)
  find_library(Python_LIBRARY ${Python_NAME}
    PATHS ${Python_ROOT_DIR}
    PATH_SUFFIXES lib Libs
  )
  if (Python_LIBRARY)
    get_filename_component(Python_LIBRARY ${Python_LIBRARY} REALPATH)
  endif ()
  SciPrintVar(Python_LIBRARY)
  get_filename_component(Python_LIBRARY_DIR ${Python_LIBRARY}/.. REALPATH)
  SciPrintVar(Python_LIBRARY_DIR)
  if (EXISTS ${Python_LIBRARY_DIR}/lib/${Python_NAME_WE})
    set(Python_MODULES_SUBDIR lib/${Python_NAME_WE})
    set(Python_MODULES_DIR ${Python_LIBRARY_DIR}/lib/${Python_NAME_WE})
    SciPrintVar(Python_MODULES_SUBDIR)
    SciPrintVar(Python_MODULES_DIR)
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

