# - FindSciGraphviz: Module to find cppcheck
#
# Module usage:
#   find_package(SciGraphviz ...)
#
# This module will define the following variables:
#  GRAPHVIZ_FOUND         = Whether Graphviz was found
#  Graphviz_cppcheck    = Path to cppcheck executable

######################################################################
#
# SciGraphviz: Find Graphviz
#
# $Id$
#
# Copyright 2011-2014, Tech-X Corporation, Boulder, CO.
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
#
######################################################################

message("")
message("--------- FindSciGraphviz looking for cppcheck ---------")

SciFindPackage(PACKAGE Graphviz
  PROGRAMS "dot"
)

if (GRAPHVIZ_FOUND)
  message(STATUS "Graphviz_cppcheck found.")
  message(STATUS "Graphviz_cppcheck = ${Graphviz_cppcheck}")
else ()
  message(STATUS "Graphviz_cppcheck not found. API documentation cannot be built.")
  set(ENABLE_DEVELDOCS FALSE)
endif ()

