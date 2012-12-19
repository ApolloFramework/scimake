# - FindTxSsh: Module to find include directories and libraries for
#   TxSsh. TxSsh is an in-house C++ Ssh package that uses ne7ssh api.
#
# This module can be included in CMake builds in find_package:
#   find_package(TxSsh REQUIRED)
#
# This module will define the following variables:
#  HAVE_TXSSH         = Whether have the TxSsh library
#  TxSsh_INCLUDE_DIRS = Location of TxSsh includes
#  TxSsh_LIBRARY_DIRS = Location of TxSsh libraries
#  TxSsh_LIBRARIES    = Required libraries, libTxSsh

######################################################################
#
# FindTxSsh: find includes and libraries for TxSsh.
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

if (USE_CC4PY_LIBS)
  set(instdirs txssh-cc4py txssh-sersh)
elseif (BUILD_WITH_SHARED_RUNTIME OR USE_SHARED_LIBS OR ENABLE_SHARED)
  set(instdirs txssh-sersh)
else ()
  set(instdirs txssh)
endif ()

set(SUPRA_SEARCH_PATH ${SUPRA_SEARCH_PATH})

SciFindPackage(
  PACKAGE "TxSsh"
  INSTALL_DIRS ${instdirs}
  HEADERS "TxSsh.h"
  LIBRARIES "txssh"
)

if (TXSSH_FOUND)
  message(STATUS "Found TxSsh")
  set(HAVE_TXSSH 1 CACHE BOOL "Whether have the TxSsh library")
else ()
  message(STATUS "Did not find TxSsh.  Use -DTXSSH_DIR to specify the installation directory.")
  if (TxSsh_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

