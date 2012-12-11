# - FindSciQt3D: Module to find include directories and
#   libraries for SciQt3D.
#
# Module usage:
#   find_package(SciQt3D ...)
#
# This module will define the following variables:
#  Qt3D_INCLUDE_DIRS = Location of Qt3D includes
#  Qt3D_LIBRARY      = The Qt3D library

######################################################################
#
# FindSciQt3D: find includes and libraries for qted
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

# Assume Qt found
if (NOT QT_DIR)
  set(QT3D_FOUND FALSE)
  return()
endif ()
if (APPLE)
  set(QT3D_FRAMEWORK_DIR ${QT_LIBRARY_DIR}/Qt3D.framework)
  set(QT3D_INCLUDE_DIR ${QT3D_FRAMEWORK_DIR}/Headers)
  set(QT3D_LIBRARY ${QT3D_FRAMEWORK_DIR}/Qt3D)
else ()
  set(QT3D_INCLUDE_DIR ${QT_DIR}/include)
  set(QT3D_LIBRARY ${QT_DIR}/lib/Qt3D)
endif ()

set(QT3D_FOUND TRUE)
foreach (i QT3D_INCLUDE_DIR QT3D_LIBRARY)
  # message(STATUS "${i} = ${${i}}.")
  if (EXISTS ${${i}})
    get_filename_component(${i} "${${i}}" REALPATH)
    message(STATUS "${i} = ${${i}}.")
  else ()
    message(STATUS "${${i}} does not exist.")
    set(QT3D_FOUND FALSE)
  endif ()
endforeach ()
message(STATUS "QT3D_FOUND = ${QT3D_FOUND}.")

