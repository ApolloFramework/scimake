# - FindSciFftw: Module to find include directories and
#   libraries for Fftw.
#
# Module usage:
#   find_package(SciFftw ...)
#
# This module will define the following variables:
#  HAVE_FFTW, FFTW_FOUND = Whether libraries and includes are found
#  Fftw_INCLUDE_DIRS       = Location of Fftw includes
#  Fftw_LIBRARY_DIRS       = Location of Fftw libraries
#  Fftw_LIBRARIES          = Required libraries

######################################################################
#
# SciFindFftw: find includes and libraries for txbase
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

# This is for finding 'dev' cmake version
if (DEFINED FFTW_FIND_VERSION)
  set(Fftw_SEARCH "fftw${FFTW_FIND_VERSION}")
else()
  set(Fftw_SEARCH "fftw")
endif()


if (ENABLE_PARALLEL)
  message(STATUS "Looking for parallel FFTW")
  SciFindPackage(PACKAGE "Fftw"
                INSTALL_DIR ${Fftw_SEARCH}-par
#                INSTALL_DIR "fftw-par"
                HEADERS "fftw.h;rfftw.h;fftw_mpi.h;rfftw_mpi.h"
                LIBRARIES "fftw;rfftw;fftw_mpi;rfftw_mpi"
                MODULES "fftw"
                )
else ()
  message(STATUS "Looking for serial FFTW")
  SciFindPackage(PACKAGE "Fftw"
                INSTALL_DIR ${Fftw_SEARCH}
#                INSTALL_DIR "fftw"
                HEADERS "fftw.h;rfftw.h"
                LIBRARIES "fftw;rfftw"
                MODULES "fftw"
                )
endif ()

if (FFTW_FOUND)
  message(STATUS "Found Fftw")
  set(HAVE_FFTW 1 CACHE BOOL "Whether have the FFTWlibrary")
else ()
  message(STATUS "Did not find Fftw.  Use -DFFTW_DIR to specify the installation directory.")
  if (SciFftw_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()
