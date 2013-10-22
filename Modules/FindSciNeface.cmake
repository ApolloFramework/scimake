# - FindNeface: Module to find include directories and
#   libraries for neface.
#
# Module usage:
#   find_package(SciNeface ...)
#
# This module will define the following variables:
#  HAVE_NEFACE, NEFACE_FOUND = Whether libraries and includes are found
#  Neface_INCLUDE_DIRS       = Location of Neface includes
#  Neface_LIBRARY_DIRS       = Location of Neface libraries
#  Neface_LIBRARIES          = Required libraries
#
# ========= ========= ========= ========= ========= ========= ==========
#
# Variables used by this module, which can be set before calling find_package
# to influence default behavior
#
# Neface_ROOT_DIR          Specifies the root dir of the Neface installation
#
# BUILD_WITH_CC4PY_RUNTIME Specifies to look for installation dirs,
#                          neface-cc4py or neface-sersh
# ENABLE_SHARED OR BUILD_WITH_SHARED_RUNTIME OR BUILD_SHARED_LIBS
#                          operative if BUILD_WITH_CC4PY_RUNTIME not set
#                          Specify to look for installation dir, neface-sersh.

######################################################################
#
# FindNeface: find includes and libraries for neface
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

if (USE_NEFACE_SERMD)
  set(instdirs neface-sermd)
else ()
  set(instdirs neface)
endif ()

if (APPLE)
  set(desiredLibraries "libnefaceStatic.a" "libneface.dylib")
elseif (WIN32)
  set(desiredLibraries "nefaceStatic.lib" "neface.lib")
else ()
  set(desiredLibraries "libnefaceStatic.a" "libneface.so")
endif () 

set(desiredHeaders neface.h)

message(STATUS "SciFindPackage called with: INSTALL_DIRS ${instdirs} LIBRARIES ${desiredLibraries}")

SciFindPackage(PACKAGE "Neface"
  INSTALL_DIRS ${instdirs}
  HEADERS ${desiredHeaders}
  LIBRARIES ${desiredLibraries}
  LIBRARY_SUBDIRS lib
)

if (NEFACE_FOUND)
  # message(STATUS "Found Neface.")
  set(HAVE_NEFACE 1 CACHE BOOL "Whether have Neface library")
else ()
  message(STATUS "Did not find Neface.  Use -DNEFACE_ROOT_DIR to specify the installation directory.")
  if (Neface_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

