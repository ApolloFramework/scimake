# - FindSciExodusii: Module to find include directories and libraries
#   for Edodus II. This module was implemented as there is no stock
#   CMake module for Edodus II.
#
# This module can be included in CMake builds in find_package:
#   find_package(SciExodusii REQUIRED)
#
# This module will define the following variables:
#  HAVE_EXODUSII   = Whether have the Netcdf library
#  Exodusii_INCLUDE_DIRS = Location of Netcdf_cmake includes
#  Exodusii_LIBRARY_DIRS = Location of Netcdf_cmake libraries
#  Exodusii_LIBRARIES    = Required libraries
#  Exodusii_STLIBS       = Location of Netcdf_cmake static library

######################################################################
#
# SciFindNetcdf_cmake: find includes and libraries for Netcdf_cmake.
#
# $Id: FindSciNetcdf_cmake.cmake 58 2012-09-15 13:43:53Z jrobcary $
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

set(instdirs exodusii)

set(desiredlibs exodusII)
set(desiredIncs "exodusII.h" "exodusII_int.h")

SciFindPackage(PACKAGE "Exodusii"
  INSTALL_DIR ${instdirs}
  HEADERS     ${desiredIncs}
  LIBRARIES   ${desiredlibs}
)

if (EXODUSII_FOUND)
  message(STATUS "Found Exodusii")
  set(HAVE_EXODUSII 1 CACHE BOOL "Whether have the EXODUSII library")
else ()
  message(STATUS "Did not find Exodusii.  Use -DEXODUSII_DIR to specify the installation directory.")
  if (SciExodusii_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

