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
SciGetInstSubdirs(openssl instdirs)
set(instdirs openssl openssl-sersh)

# Libraries have different names on Windows.  Use static MD or MT libs.
if (WIN32)
  set(ssl_libs ssleay32 libeay32)
else ()
  set(ssl_libs ssl crypto)
endif ()

SciFindPackage(PACKAGE "OpenSsl"
  INSTALL_DIRS ${instdirs}
  EXECUTABLES openssl
  HEADERS openssl/ssl.h
  LIBRARIES ${ssl_libs}
  # INCLUDE_SUBDIRS include
  # LIBRARY_SUBDIRS lib/VC/static lib
)

# On Windows, if failed, try again with system paths
if (WIN32 AND NOT OPENSSL_FOUND)
  if (EXISTS C:/OpenSSL AND NOT OpenSsl_ROOT_DIR)
    set(OpenSsl_ROOT_DIR C:/OpenSSL)
  else ()
    find_program(openssl_exec openssl)
    if (openssl_exec)
      get_filename_component(openssl_bindir ${openssl_exec}/.. REALPATH)
      get_filename_component(OpenSsl_ROOT_DIR ${openssl_bindir}/.. REALPATH)
    endif ()
  endif ()
  if (OpenSsl_ROOT_DIR)
    SciFindPackage(PACKAGE "OpenSsl"
      INSTALL_DIRS ${instdirs}
      EXECUTABLES openssl
      HEADERS openssl/ssl.h
      LIBRARIES ${ssl_libs}
      # INCLUDE_SUBDIRS include
      # LIBRARY_SUBDIRS lib/VC/static lib.  This search gives dll libs
    )
  endif ()
endif ()

# Correct static libraries on Windows
if (WIN32)
  set(srchlibs ${OpenSsl_LIBRARIES})
  set(OpenSsl_STLIBS)
  set(OpenSsl_MDLIBS)
  foreach (lib ${srchlibs})
    get_filename_component(openssl_libdir ${lib}/.. REALPATH)
    get_filename_component(openssl_libname ${lib} NAME_WE)
    # message(STATUS "Looking for ${openssl_libname}MD in ${openssl_libdir}/VC/static.")
    find_library(mdlib ${openssl_libname}MD PATHS ${openssl_libdir}/VC/static
      NO_DEFAULT_PATH
    )
    set(OpenSsl_MDLIBS ${OpenSsl_MDLIBS} ${mdlib})
    find_library(stlib ${openssl_libname}MT PATHS ${openssl_libdir}/VC/static
      NO_DEFAULT_PATH
    )
    set(OpenSsl_STLIBS ${OpenSsl_STLIBS} ${stlib})
  endforeach ()
  message(STATUS "After correction.")
  SciPrintVar(OpenSsl_STLIBS)
  SciPrintVar(OpenSsl_MDLIBS)
endif ()

# Finish up
if (OPENSSL_FOUND)
  # message(STATUS "Found OpenSsl")
  set(HAVE_OPENSSL 1 CACHE BOOL "Whether have the OPENSSL library")
else ()
  message(STATUS "Did not find OpenSsl.  Use -DOpenSsl_ROOT_DIR to specify the installation directory.")
  if (SciOpenSsl_FIND_REQUIRED)
    message(FATAL_ERROR "Failing.")
  endif ()
endif ()

