# - FindOce: Module to find include directories and
#   libraries for Opencascade Community Edition
#
# Module usage:
#   find_package(Oce ...)
#
# This module will define the following variables:
#  HAVE_TXBASE, TXBASE_FOUND = Whether libraries and includes are found
#  Oce_INCLUDE_DIRS       = Location of Oce includes
#  Oce_LIBRARY_DIRS       = Location of Oce libraries
#  Oce_LIBRARIES          = Required libraries

######################################################################
#
# FindOce: find includes and libraries for OCE
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

# Uses of these libs found from CMakeLists.txt in OCE
# Analyze dependencies using otool -L on OS X.
# Below is a layered list, top to bottom, left to right.
# ToDo: define the SEARCHHDRS
set(OceIges_SEARCHLIBS TKIGES)
# IGES dependency
set(OceAdvGeom_SEARCHLIBS TKFillet TKBool TKPrim TKBO)
set(OceStep_SEARCHLIBS TKSTEP TKSTEP209 TKSTEPAttr TKSTEPBase)
# STEP and IGES depend on this, but not STL
set(OceIoBase_SEARCHLIBS TKXSBase)
set(OceStl_SEARCHLIBS TKSTL)
set(OceAlgo_SEARCHLIBS TKShHealing TKTopAlgo TKGeomAlgo)
set(OceGeom_SEARCHLIBS TKBrep TKGeomBase TKG3d TKG2d)
set(OceTools_SEARCHLIBS TKMath TKAdvTools)
set(OceKernel_SEARCHLIBS TKernel)

# Enforce dependencies
if (OceIges_FIND)
  set(OceAdvGeom_FIND TRUE)
  set(OceIoBase_FIND TRUE)
endif ()
if (OceStep_FIND)
  set(OceIoBase_FIND TRUE)
endif ()
if (OceIoBase_FIND OR OceStl_FIND)
  set(OceAlgo_FIND TRUE)
endif ()
if (OceAlgo_FIND)
  set(OceGeom_FIND TRUE)
endif ()
if (OceGeom_FIND)
  set(OceTools_FIND TRUE)
endif ()
if (OceTools_FIND)
  set(OceKernel_FIND TRUE)
endif ()

# Set the libraries
set(Oce_SEARCHLIBS)
foreach (pkg Iges AdvGeom Step IoBase Stl Algo Geom Tools Kernel)
  message(STATUS "Oce${pkg}_FIND = ${Oce${pkg}_FIND}.")
  if (Oce${pkg}_FIND)
    set(Oce_SEARCHLIBS ${Oce_SEARCHLIBS} ${Oce${pkg}_SEARCHLIBS})
  endif ()
endforeach ()
message(STATUS "Oce_SEARCHLIBS = ${Oce_SEARCHLIBS}.")

# Worry about data exchange later
#  TKVRML TKXCAF TKXCAFSchema TKXmlXCAF TKBinXCAF TKXDEIGES TKXDESTEP

# To Do: Set variables for each group individually
SciFindPackage(PACKAGE "Oce"
  HEADERS "TopoDS_Builder.hxx"
  LIBRARIES "${Oce_SEARCHLIBS}"
)

