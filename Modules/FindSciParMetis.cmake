# - FindSciParMetis: Module to find include directories and libraries
#   for ParMetis. This module was implemented as there is no stock
#   CMake module for ParMetis.
#   It also looks for the corresponding libmetis.a
#
# This module can be included in CMake builds in find_package:
#   find_package(SciParMetis REQUIRED)
#
# This module will define the following variables:
#  HAVE_PARMETIS         = Whether have the ParMetis library
#  ParMetis_INCLUDE_DIRS = Location of ParMetis includes
#  ParMetis_LIBRARY_DIRS = Location of ParMetis libraries
#  ParMetis_LIBRARIES    = Required libraries
#  ParMetis_STLIBS       = Location of ParMetis static library

######################################################################
#
# SciFindParMetis: find includes and libraries for ParMetis.
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################
set(SUPRA_SEARCH_PATH ${SUPRA_SEARCH_PATH})

SciFindPackage(PACKAGE "ParMetis"
              INSTALL_DIR "parmetis-par"
              HEADERS "parmetis.h"
              LIBRARIES "parmetis;metis"
              )

if (PARMETIS_FOUND)
  message(STATUS "Found ParMetis")
  set(HAVE_PARMETIS 1 CACHE BOOL "Whether have the PARMETIS library")
else ()
  message(STATUS "Did not find ParMetis.  Use -DPARMETIS_DIR to specify the installation directory.")
  if (SciParMetis_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

