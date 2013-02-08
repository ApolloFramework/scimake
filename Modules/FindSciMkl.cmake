# - FindSciMkl: Module to find include directories and
#   libraries for Mkl.
#
# Module usage:
#   find_package(SciMkl ...)
#
# This module will define the following variables:
#  HAVE_MKL, MKL_FOUND = Whether libraries and includes are found
#  Mkl_INCLUDE_DIRS = Location of Mkl includes
#  Mkl_LIBRARY_DIRS = Location of Mkl libraries
#  Mkl_LIBRARIES    = Required libraries

######################################################################
#
# FindSciMkl: find includes and libraries for txbase
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

SciFindPackage(PACKAGE "Mkl"
              LIBRARIES "mkl_intel_thread;mkl_blas95_lp64;mkl_lapack95_lp64;mkl_core;mkl_rt.lib"
              )

if (MKL_FOUND)
  message(STATUS "Mkl found.")
  set(HAVE_MKL 1 CACHE BOOL "Whether have Mkl")
else ()
  message(STATUS "Did not find Mkl.  Use -DMkl_ROOT_DIR to specify the installation directory.")
  if (SciMkl_FIND_REQUIRED)
    message(FATAL_ERROR "Finding MKL failed")
  endif ()
endif ()

