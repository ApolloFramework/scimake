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

if (USE_CC4PY_LIBS)
  set(instdirs openssl-cc4py openssl-sersh)
elseif (WIN32 AND BUILD_WITH_SHARED_RUNTIME)
  set(instdirs openssl-sermd)
elseif (USE_SHARED_LIBS OR BUILD_SHARED_LIBS OR ENABLE_SHARED OR BUILD_WITH_SHARED_RUNTIME)
  set(instdirs openssl-sersh openssl)
else ()
  set(instdirs openssl)
endif ()

SciFindPackage(PACKAGE "OpenSsl"
  INSTALL_DIRS ${instdirs}
  EXECUTABLES openssl
  HEADERS ssl.h
  LIBRARIES ssl crypto
  INCLUDE_SUBDIRS include include/openssl
)

# On Windows, if failed, try again with system paths
if (WIN32 AND NOT OPENSSL_FOUND)
  if (EXISTS C:/OpenSSL AND NOT OpenSsl_ROOT_DIR)
    set(OpenSsl_ROOT_DIR C:/OpenSSL)
    SciFindPackage(PACKAGE "OpenSsl"
      INSTALL_DIRS ${instdirs}
      EXECUTABLES openssl
      HEADERS ssl.h
      LIBRARIES openssl crypto
      INCLUDE_SUBDIRS include include/openssl
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

