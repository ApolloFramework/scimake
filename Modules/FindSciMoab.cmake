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

# Finding sersh for all projects now, if at some time
# later we are building ser and sersh, then we will have
# to adjust this...
set(instdirs moab-sersh)

set(Moab_LIBRARY_LIST
  MOAB dagmc iMesh
)

SciFindPackage(
  PACKAGE "Moab"
  INSTALL_DIRS ${instdirs}
  HEADERS "MBCore.hpp"
  LIBRARIES ${Moab_LIBRARY_LIST}
)

if (MOAB_FOUND)
  message(STATUS "Found Moab")
else ()
  message(STATUS "Did not find Moab.  Use -DMoab_ROOT_DIR to specify the installation directory.")
endif ()

