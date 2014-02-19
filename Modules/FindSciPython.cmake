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
find_program(Python_EXE python)
if (Python_EXE)
  get_filename_component(Python_EXE ${Python_EXE} REALPATH)
  get_filename_component(Python_NAME ${Python_EXE} NAME)
  get_filename_component(Python_BINDIR ${Python_EXE}/.. REALPATH)
  # SciPrintVar(Python_BINDIR)
  get_filename_component(Python_BINDIR_NAME ${Python_BINDIR} NAME)
  # SciPrintVar(Python_BINDIR_NAME)
  if ("${Python_BINDIR_NAME}" STREQUAL bin)
    get_filename_component(Python_ROOT_DIR ${Python_EXE}/../.. REALPATH)
  else ()
    get_filename_component(Python_ROOT_DIR ${Python_EXE}/.. REALPATH)
  endif ()
endif ()
SciPrintVar(Python_EXE)
SciPrintVar(Python_NAME)
SciFindPackage(
  PACKAGE Python
  HEADERS Python.h
  INCLUDE_SUBDIRS include/python2.7 include/python2.6 include
  LIBRARIES python27 python2.7 python26 python2.6 python OPTIONAL
  LIBRARY_SUBDIRS lib Libs
)

if (PYTHON_FOUND)
  message(STATUS "[FindSciPython.cmake] - Found Python")
  set(HAVE_PYTHON 1 CACHE BOOL "Whether have Python.")
else ()
  message(STATUS "[FindSciPython.cmake] - Did not find Python, use -DPython_ROOT_DIR to supply the Python installation directory.")
  if (SciPython_FIND_REQUIRED)
    message(FATAL_ERROR "[FindSciPython.cmake] - Failing.")
  endif ()
endif ()

