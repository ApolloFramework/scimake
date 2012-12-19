# - FindSciLibsshn: Module to find include directories and libraries
#   for Libssh. This module was implemented as there is no stock
#   CMake module for Libssh. This is currently being used by QuIDS
#   project.
#
# This module can be included in CMake builds in find_package:
#   find_package(SciLibssh REQUIRED)
#
# Input variables
# ENABLE_SHARED if true, will look for shared installation of libssh
# USE_SHARED_LIBS same as above.
#
# This module will define the following variables:
#  HAVE_LIBSSH         = Whether have the Libssh library
#  Libssh_INCLUDE_DIRS = Location of Libssh includes
#  Libssh_LIBRARY_DIRS = Location of Libssh libraries
#  Libssh_LIBRARIES    = Required libraries
#  Libssh_STLIBS       = Location of Libssh static library

######################################################################
#
# SciFindLibssh: find includes and libraries for Libssh.
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

# set(SUPRA_SEARCH_PATH ${SUPRA_SEARCH_PATH})

if (ENABLE_SHARED OR USE_SHARED_LIBS)
  set(instdirs "libssh-cc4py;libssh-sersh")
else ()
  set(instdirs "libssh")
endif ()

SciFindPackage(
  PACKAGE "Libssh"
  INSTALL_DIRS ${instdirs}
  HEADERS "libssh/libssh.h"
  LIBRARIES "ssh"
)

if (LIBSSH_FOUND)
  message(STATUS "Found Libssh")
  set(HAVE_LIBSSH 1 CACHE BOOL "Whether have the LIBSSH library")
else ()
  message(STATUS "Did not find Libssh.  Use -DLibssh_ROOT_DIR to specify the installation directory.")
  if (SciLibssh_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

