# - FindSciMuparser: Module to find include directories and
#   libraries for Muparser.
#
# Module usage:
#   find_package(SciMuparser ...)
#
# This module will define the following variables:
#  HAVE_MUPARSER, MUPARSER_FOUND = Whether libraries and includes are found
#  Muparser_INCLUDE_DIRS       = Location of Muparser includes
#  Muparser_LIBRARY_DIRS       = Location of Muparser libraries
#  Muparser_LIBRARIES          = Required libraries

######################################################################
#
# FindMuparser: find includes and libraries for muparser
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

set(instdirs "muparser")
if (USE_SHARED_LIBS)
  set(instdirs "muparser-sersh")
endif()

SciFindPackage(PACKAGE "Muparser"
              INSTALL_DIR ${instdirs} 
              HEADERS "muParser.h"
              LIBRARIES "muparser"
              INCLUDE_SUBDIRS "include"
              LIBRARY_SUBDIRS "lib"
              )

if (MUPARSER_FOUND)
  message(STATUS "Found Muparser")
  set(HAVE_MUPARSER 1 CACHE BOOL "Whether have the MUPARSER library")
else ()
   message(STATUS "Did not find Muparser.  Use -DMUPARSER_DIR to specify the installation directory.")
   if (SciMuparser_FIND_REQUIRED)
       message(FATAL_ERROR "Failing.")
   endif ()
endif ()

