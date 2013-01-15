# - FindTxBase: Module to find include directories and
#   libraries for TxBase.
#
# Module usage:
#   find_package(TxBase ...)
#
# This module will define the following variables:
#  HAVE_TXBASE, TXBASE_FOUND = Whether libraries and includes are found
#  TxBase_INCLUDE_DIRS       = Location of TxBase includes
#  TxBase_LIBRARY_DIRS       = Location of TxBase libraries
#  TxBase_LIBRARIES          = Required libraries

######################################################################
#
# FindTxBase: find includes and libraries for txbase
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

if (ENABLE_PARALLEL)
  if (BUILD_WITH_SHARED_RUNTIME OR USE_SHARED_HDF5)
    set(instdirs txbase-parsh)
  else ()
    set(instdirs txbase-par txbase-ben)
  endif ()
else ()
  if (BUILD_WITH_CC4PY_RUNTIME OR USE_CC4PY_HDF5)
    set(instdirs txbase-cc4py txbase-sersh)
  elseif (BUILD_WITH_SHARED_RUNTIME OR USE_SHARED_HDF5)
    set(instdirs txbase-sersh)
  else ()
    set(instdirs txbase)
  endif ()
endif ()

if (NOT_HAVE_STD_ABS_DOUBLE)
  set(txbasefindlibs txbase txstd)
else ()
  set(txbasefindlibs txbase)
endif ()

SciFindPackage(PACKAGE "TxBase"
  INSTALL_DIRS ${instdirs}
  HEADERS "txbase_version.h"
  LIBRARIES "${txbasefindlibs}"
  LIBRARY_SUBDIRS "lib/${CXX_COMP_LIB_SUBDIR};lib"
)

if (TXBASE_FOUND)
  # message(STATUS "Found TxBase.")
  set(HAVE_TXBASE 1 CACHE BOOL "Whether have TxBase library")
else ()
  message(STATUS "Did not find TxBase.  Use -DTXBASE_DIR to specify the installation directory.")
  if (TxBase_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

