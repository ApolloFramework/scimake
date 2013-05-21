# - FindSciEigen3: Module to find include directories for Eigen3.
#
# Module usage:
#   find_package(SciEigen3 ...)
#
# Variables used by this module, which can be set before calling find_package
# to influence default behavior
# Eigen3_ROOT_DIR          Specifies the root dir of the eigen3 installation
#
# This module will define the following variables:
#  HAVE_EIGEN3,EIGEN3_FOUND = Whether libraries and includes are found
#  Eigen3_INCLUDE_DIRS       = Location of Gsl includes

######################################################################
#
# FindEigen3: find includes for Eigen3
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

# Try to find an installation of eigen3 in the system include directory.
SciFindPackage(PACKAGE "Cusp"
              INSTALL_DIR "cusp"
              HEADERS "version.h"
              )

if (CUSP_FOUND)
  message(STATUS "Found Cusp")
  set(HAVE_CUSP 1 CACHE BOOL "Whether have Cusp")
else ()
  message(STATUS "Did not find Cusp.  Use -DCUSP_DIR to specify the installation directory.")
  if (SciCusp_FIND_REQUIRED)
    message(FATAL_ERROR "Failed.")
  endif ()
endif ()

