# - FindSciCppCheck: Module to find cppcheck and setup apidocs target for
#   CppCheck.
#
# Module usage:
#   find_package(SciCppCheck ...)
#
# This module will define the following variables:
#  CPPCHECK_FOUND         = Whether CppCheck was found
#  CppCheck_cppcheck    = Path to cppcheck executable

######################################################################
#
# SciCppCheck: Find CppCheck and set up apidocs target
#
# $Id$
#
# Copyright 2011-2014, Tech-X Corporation, Boulder, CO.
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
#
######################################################################

message("")
message("--------- FindSciCppCheck looking for cppcheck ---------")

SciFindPackage(PACKAGE CppCheck
  PROGRAMS "cppcheck"
)

if (CPPCHECK_FOUND)
  message(STATUS "CppCheck_cppcheck found.")
  message(STATUS "CppCheck_cppcheck = ${CppCheck_cppcheck}")
else ()
  message(STATUS "CppCheck_cppcheck not found. API documentation cannot be built.")
  set(ENABLE_DEVELDOCS FALSE)
endif ()

