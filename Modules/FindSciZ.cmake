# - FindSciZ: Module to find include directories and
#   libraries for Z.
#
# Module usage:
#   find_package(SciZ ...)
#
# This module will define the following variables:
#  HAVE_Z, Z_FOUND = Whether libraries and includes are found
#  Z_INCLUDE_DIRS       = Location of Z includes
#  Z_LIBRARY_DIRS       = Location of Z libraries
#  Z_LIBRARIES          = Required libraries

######################################################################
#
# SciFindZ: find includes and libraries for z(compression)
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
  PACKAGE "Z"
  INSTALL_DIRS zlib
  LIBRARIES z zlib zlib1 OPTIONAL
)

if (WIN32)
# Find the dlls
  get_filename_component(Z_ROOT_DIR ${Z_LIBRARY_DIRS}/.. REALPATH)
  SciPrintVar(Z_ROOT_DIR)
# This is cached, so need a new variable name
  find_file(temp_z_dlls
    NAMES z zlib zlib1
    PATHS ${Z_ROOT_DIR}
    PATH_SUFFIXES bin
    NO_DEFAULT_PATH
  )
  SciPrintVar(Z_DLLS)
endif ()

if (Z_FOUND)
  # message(STATUS "Found Z(compression library)")
  set(HAVE_Z 1 CACHE BOOL "Whether have the z(compression) library")
else ()
  message(STATUS "Did not find Z(compression).")
  if (SciZ_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

