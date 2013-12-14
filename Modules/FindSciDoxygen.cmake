# - FindSciDoxygen: Module to find doxygen and setup apidocs target for
#   Doxygen.
#
# Module usage:
#   find_package(SciDoxygen ...)
#
# This module will define the following variables:
#  DOXYGEN_FOUND         = Whether Doxygen was found
#  DOXYGEN_PROGRAM    = Path to doxygen executable

######################################################################
#
# SciDoxygen: Find Doxygen and set up apidocs target
#
# $Id$
#
# Copyright 2011 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

message("")
message("--------- FindSciDoxygen looking for doxygen ---------")
find_package(Doxygen)

if (NOT DOXYGEN_FOUND)
  message(STATUS "Doxygen not found by default CMake module, falling back to SciFindPackage module.")
  SciFindPackage(PACKAGE Doxygen
    PROGRAMS "doxygen"
  )
  if (DOXYGEN_FOUND)
    set(DOXYGEN_PROGRAM "${Doxygen_doxygen}")
  endif ()
endif ()

if (DOXYGEN_FOUND)
  message(STATUS "DOXYGEN_PROGRAM found.")
  message(STATUS "DOXYGEN_PROGRAM = ${DOXYGEN_PROGRAM}")
else ()
  message(STATUS "DOXYGEN_PROGRAM not found. API documentation cannot be built.")
  set(ENABLE_DEVELDOCS FALSE)
endif ()

