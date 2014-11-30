# - FindSciCppcheck: Module to find cppcheck and setup apidocs target for
#   Cppcheck.
#
# Module usage:
#   find_package(SciCppcheck ...)
#
# This module will define the following variables:
#  CPPCHECK_FOUND         = Whether Cppcheck was found
#  Cppcheck_cppcheck    = Path to cppcheck executable

######################################################################
#
# SciCppcheck: Find Cppcheck and set up apidocs target
#
# $Id$
#
# Copyright 2011-2014, Tech-X Corporation, Boulder, CO.
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
#
######################################################################

message("")
message("--------- FindSciCppcheck looking for cppcheck ---------")

SciFindPackage(PACKAGE Cppcheck
  PROGRAMS "cppcheck"
)

if (CPPCHECK_FOUND)
  message(STATUS "Cppcheck_cppcheck found.")
  message(STATUS "Cppcheck_cppcheck = ${Cppcheck_cppcheck}")
else ()
  message(STATUS "Cppcheck_cppcheck not found. API documentation cannot be built.")
  set(ENABLE_DEVELDOCS FALSE)
endif ()

