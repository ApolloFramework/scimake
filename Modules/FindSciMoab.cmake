# - FindSciMoab: Module to find include directories and
#   libraries for Moab.
#
# Module usage:
#   find_package(SciMoab ...)
#
# This module will define the following variables:
#  HAVE_MOAB, MOAB_FOUND = Whether libraries and includes are found
#  Moab_INCLUDE_DIRS       = Location of Moab includes
#  Moab_LIBRARY_DIRS       = Location of Moab libraries
#  Moab_LIBRARIES          = Required libraries
#  Moab_DLLS               =

######################################################################
#
# FindMoab: find includes and libraries for hdf5
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation and other contributors.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

set(moabfindlibs dagmc iMesh MOAB)

SciGetInstSubdirs(moab instdirs)

SciFindPackage(PACKAGE "Moab"
  INSTALL_DIRS ${instdirs}
  HEADERS "MBCore.hpp"
  LIBRARIES "${moabfindlibs}"
  LIBRARY_SUBDIRS lib/${CXX_COMP_LIB_SUBDIR} lib
)

if (MOAB_FOUND)
  message(STATUS "Found Moab")
else ()
  message(STATUS "Did not find Moab.  Use -DMoab_ROOT_DIR to specify the installation directory.")
endif ()

