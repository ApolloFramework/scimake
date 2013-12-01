# - FindSciOpenSsl: Module to find include directories and
#   libraries for OpenSsl.
#
# Module usage:
#   find_package(SciOpenSsl ...)
#
# This module will define the following variables:
#  HAVE_OPENSSL, OPENSSL_FOUND   = Whether libraries and includes are found
#  OpenSsl_INCLUDE_DIRS       = Location of OpenSsl includes
#  OpenSsl_LIBRARY_DIRS       = Location of OpenSsl libraries
#  OpenSsl_LIBRARIES          = Required libraries
#  OpenSsl_DLLS               =

######################################################################
#
# FindOpenSsl: find includes and libraries for openssl
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

# OpenSSL builds its static libs inside sersh
SciGetInstDirs(openssl instdirs)
set(instdirs openssl openssl-sersh)

SciFindPackage(PACKAGE "OpenSsl"
  INSTALL_DIRS ${instdirs}
  EXECUTABLES openssl
  HEADERS openssl/ssl.h
  LIBRARIES ssl crypto
  INCLUDE_SUBDIRS include
)

# On Windows, if failed, try again with system paths
if (WIN32 AND NOT OPENSSL_FOUND)
  if (EXISTS C:/OpenSSL AND NOT OpenSsl_ROOT_DIR)
    set(OpenSsl_ROOT_DIR C:/OpenSSL)
    SciFindPackage(PACKAGE "OpenSsl"
      INSTALL_DIRS ${instdirs}
      EXECUTABLES openssl
      HEADERS openssl/ssl.h
      LIBRARIES ssl crypto
      INCLUDE_SUBDIRS include
    )
  endif ()
endif ()

if (OPENSSL_FOUND)
  # message(STATUS "Found OpenSsl")
  set(HAVE_OPENSSL 1 CACHE BOOL "Whether have the OPENSSL library")
else ()
  message(STATUS "Did not find OpenSsl.  Use -DOpenSsl_ROOT_DIR to specify the installation directory.")
  if (SciOpenSsl_FIND_REQUIRED)
    message(FATAL_ERROR "Failing.")
  endif ()
endif ()

