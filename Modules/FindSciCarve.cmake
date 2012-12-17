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

set(Carve_LIBRARY_LIST
  carve
)

SciFindPackage(
  PACKAGE Carve
  INSTALL_DIR visit_vtk
  HEADERS vtkObject.h
  LIBRARIES "${Carve_LIBRARY_LIST}"
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

