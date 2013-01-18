# - FindSciCarve: Module to find include directories and
#   libraries for Carve.
#
# Module usage:
#   find_package(SciCarve ...)
#
# This module will define the following variables:
#  HAVE_CARVE, CARVE_FOUND = Whether libraries and includes are found
#  Carve_INCLUDE_DIRS      = Location of Carve includes
#  Carve_LIBRARY_DIRS      = Location of Carve libraries
#  Carve_LIBRARIES         = Required libraries

##################################################################
#
# Find module for CARVE
#
# $Id$
#
##################################################################

if (BUILD_WITH_CC4PY_RUNTIME )
  set(instdirs carve-cc4py carve-sersh)
elseif (BUILD_WITH_SHARED_RUNTIME OR USE_SHARED_HDF5)
  set(instdirs carve-sersh)
else ()
  set(instdirs carve)
endif ()

set(Carve_LIBRARY_LIST
  carve
)

SciFindPackage(
  PACKAGE Carve
  INSTALL_DIRS ${instdirs}
  HEADERS carve.hpp
  INCLUDE_SUBDIRS include/carve include
  LIBRARIES ${Carve_LIBRARY_LIST}
  EXECUTABLES convert intersect slice triangulate view
)

if (CARVE_FOUND)
  message(STATUS "[FindSciCarve.cmake] - Found CARVE")
  message(STATUS "[FindSciCarve.cmake] - Carve_INCLUDE_DIRS = ${Carve_INCLUDE_DIRS}")
  message(STATUS "[FindSciCarve.cmake] - Carve_LIBRARIES = ${Carve_LIBRARIES}")
  set(HAVE_CARVE 1 CACHE BOOL "Whether have Carve.")
else ()
  message(STATUS "[FindSciCarve.cmake] - Did not find CARVE, use -DCARVE_DIR to supply the CARVE installation directory.")
  if (SciCarve_FIND_REQUIRED)
    message(FATAL_ERROR "[FindSciCarve.cmake] - Failing.")
  endif ()
endif ()

