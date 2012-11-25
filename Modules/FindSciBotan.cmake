# - FindSciBotann: Module to find include directories and libraries
#   for Botan. This module was implemented as there is no stock
#   CMake module for Botan. This is currently being used by QuIDS
#   project.
#
# This module can be included in CMake builds in find_package:
#   find_package(SciBotan REQUIRED)
#
# This module will define the following variables:
#  HAVE_BOTAN         = Whether have the Botan library
#  Botan_INCLUDE_DIRS = Location of Botan includes
#  Botan_LIBRARY_DIRS = Location of Botan libraries
#  Botan_LIBRARIES    = Required libraries
#  Botan_STLIBS       = Location of Botan static library

######################################################################
#
# SciFindBotan: find includes and libraries for Botan.
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

set(SUPRA_SEARCH_PATH ${SUPRA_SEARCH_PATH})

if (BUILD_WITH_CC4PY_RUNTIME OR BUILD_WITH_SHARED_RUNTIME)
  set(instdirs botan-cc4py botan-sersh)
else ()
  set(instdirs botan)
endif ()

SciFindPackage(
  PACKAGE "Botan"
  INSTALL_DIRS ${instdirs}
  HEADERS "botan/botan.h"
  LIBRARIES "botan"
)

if (BOTAN_FOUND)
  message(STATUS "Found Botan")
  set(HAVE_BOTAN 1 CACHE BOOL "Whether have the BOTAN library")
else ()
  message(STATUS "Did not find Botan.  Use -DBOTAN_DIR to specify the installation directory.")
  if (SciBotan_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

