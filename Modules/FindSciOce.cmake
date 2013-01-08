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

set(Oce_SEARCHLIBS
  TKBRep
  TKPrim
  TKSTEP TKSTEP209 TKSTEPAttr TKSTEPBase
  TKSTL
  TKernel
)

SciFindPackage(PACKAGE "Oce"
  HEADERS "TopoDS_Builder.hxx"
  LIBRARIES "${Oce_SEARCHLIBS}"
)

