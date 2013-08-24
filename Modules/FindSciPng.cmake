# - FindSciPng: Module to find include directories and
#   libraries for Png.
#
# Module usage:
#   find_package(SciPng ...)
#
# This module will define the following variables:
#  HAVE_PNG, PNG_FOUND = Whether libraries and includes are found
#  Png_INCLUDE_DIRS       = Location of Png includes
#  Png_LIBRARY_DIRS       = Location of Png libraries
#  Png_LIBRARIES          = Required libraries

######################################################################
#
# SciFindPng: find includes and libraries for z(compression)
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

SciFindPackage(
  PACKAGE "Png"
  INSTALL_DIRS zlib
  HEADERS png.h
  LIBRARIES "png"
)

if (PNG_FOUND)
  # message(STATUS "Found Png(compression library)")
  set(HAVE_PNG 1 CACHE BOOL "Whether have the z(compression) library")
else ()
  message(STATUS "Did not find Png(compression).")
  if (SciPng_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()
