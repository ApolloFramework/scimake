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
#  Mkl_STLIB        = Static libraries
#  Iomp5_LIBRARIES  = Openmp intel libraries

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

if (WIN32)
  #foreach(year 2011 2012 2013)
    #set(Mkl_ROOT_DIR "C:/Program Files (x86)/Intel/Composer XE ${year}/mkl/lib/intel64")
    set(Mkl_ROOT_DIR "C:/Program Files (x86)/Intel/Composer XE/mkl/lib/intel64")
      SciFindPackage(PACKAGE "Mkl"
                    LIBRARIES "mkl_rt"
                    )
    #set(Iomp5_ROOT_DIR "C:/Program Files (x86)/Intel/Composer XE ${year}/compiler/lib/intel64")
    set(Iomp5_ROOT_DIR "C:/Program Files (x86)/Intel/Composer XE/compiler/lib/intel64")
      SciFindPackage(PACKAGE "Iomp5"
                    LIBRARIES "libiomp5md"
                    )
    if (MKL_FOUND)
      message(STATUS "Mkl found.")
      set(HAVE_MKL 1 CACHE BOOL "Whether have Mkl")
      break()
    endif ()
  #endforeach()
else (WIN32)
  #foreach(year 2011 2012 2013)
    set(Mkl_ROOT_DIR "/usr/local/intel/mkl/lib/intel64")
      SciFindPackage(PACKAGE "Mkl"
                    LIBRARIES "mkl_rt"
                    )
    set(Iomp5_ROOT_DIR "/usr/local/intel/lib/intel64")
      SciFindPackage(PACKAGE "Iomp5"
                    LIBRARIES "iomp5"
                    )
    if (MKL_FOUND)
      message(STATUS "Mkl found.")
      set(HAVE_MKL 1 CACHE BOOL "Whether have Mkl")
      #break()
    endif ()
  #endforeach()
endif (WIN32)

if (NOT MKL_FOUND)
  message(STATUS "Did not find Mkl.  Use -DMkl_ROOT_DIR to specify the installation directory.")
  if (SciMkl_FIND_REQUIRED)
    message(FATAL_ERROR "Finding MKL failed.")
  endif ()
endif ()

