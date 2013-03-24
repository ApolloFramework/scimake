# - FindSciVsrw: Module to find include directories and libraries
#   for Vsrw, VizSchema read-write library. This module was 
#   implemented as there is no stock CMake module for Vsrw.
#
# This module can be included in CMake builds in find_package:
#   find_package(SciVsrw REQUIRED)
#
# This module will define the following variables:
#  HAVE_VSRW         = Whether have the Vsrw library
#  Vsrw_INCLUDE_DIRS = Location of Vsrw includes
#  Vsrw_LIBRARY_DIRS = Location of Vsrw libraries
#  Vsrw_LIBRARIES    = Required libraries
#  Vsrw_STLIBS       = Location of Vsrw static library

######################################################################
#
# SciFindVsrw: find includes and libraries for Vsrw.
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

# only serial
set(instdirs vsrw)

set(desiredlibs vsrw)
set(desiredheaders VsApi.h VsLog.h VsRectilinearMesh.h VsUnstructuredMesh.h
                   VsAttribute.h VsMDMesh.h VsRegistry.h VsUtils.h
                   VsDataset.h VsMDVariable.h VsRegistryObject.h VsVariable.h
                   VsFile.h VsMesh.h VsSchema.h VsVariableWithMesh.h
                   VsFilter.h VsObject.h VsStructuredMesh.h
                   VsGroup.h VsReader.h VsUniformMesh.h)
SciFindPackage(PACKAGE "Vsrw"
  INSTALL_DIR ${instdirs}
  HEADERS ${desiredheaders}
  LIBRARIES ${desiredlibs}
  MODULES "vsrw"
)

if (VSRW_FOUND)
  message(STATUS "Found Vsrw")
  set(HAVE_VSRW 1 CACHE BOOL "Whether have the Vsrw library")
else ()
  message(STATUS "Did not find Vsrw.  Use -DVSRW_DIR to specify the installation directory.")
  if (SciVsrw_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

