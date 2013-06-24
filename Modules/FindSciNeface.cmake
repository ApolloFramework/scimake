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

if (ENABLE_PARALLEL)
  if (BUILD_WITH_SHARED_RUNTIME)
    set(instdirs neface-parsh)
  else ()
    set(instdirs neface-par neface-ben)
  endif ()
else ()
  if (USE_NEFACE_SERMD)
    set(instdirs neface-sermd)
  elseif (USE_CC4PY_LIBS)
    set(instdirs neface-cc4py neface-sersh)
  elseif (USE_SHARED_LIBS OR BUILD_SHARED_LIBS OR ENABLE_SHARED OR BUILD_WITH_SHARED_RUNTIME OR USE_SHARED_HDF5)
    set(instdirs neface-sersh)
  else ()
    set(instdirs neface)
  endif ()
endif ()

#if (NOT_HAVE_STD_ABS_DOUBLE)
#  set(nefacefindlibs neface txstd)
#else ()
#  set(nefacefindlibs neface)
#endif ()

set(desiredHeaders NfCuboidElementIterator.h NfPointListType.hpp
                   NfCuboidElementIteratorType.hpp NfPolynomial.h NfCuboid.h
                   NfPolynomialType.hpp NfCuboidNodeIterator.h NfSimplex.h
                   NfCuboidNodeIteratorType.hpp NfSimplexType.hpp NfCuboidType.hpp
                   NfSimplexVTKViz.h NfCuboidVTKViz.h NfSimplexVTKVizType.hpp
                   NfCuboidVTKVizType.hpp NfSolve.h NfCuboidWhitney.h
                   NfStructuredField.h NfCuboidWhitneyType.hpp
                   NfStructuredFieldType.hpp NfFunction.h NfStructuredGrid.h
                   NfJacobianMatrix.h NfStructuredGridType.hpp NfMetricTensor.h
                   NfTensor.h NfNestedBoxIterator.h NfTensorType.hpp
                   NfNestedBoxIteratorType.hpp NfUnstructuredGrid.h NfPForm.h
                   NfUnstructuredGridType.hpp NfPFormIterator.h NfVector.h
                   NfPFormIteratorType.hpp NfVectorType.hpp NfPFormType.hpp
                   NfWhitney.h NfPointList.h NfWhitneyType.hpp)

SciFindPackage(PACKAGE "Neface"
  INSTALL_DIRS ${instdirs}
  HEADERS ${desiredHeaders}
  LIBRARIES "libneface.so"
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

