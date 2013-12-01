# - FindSciHdf5: Module to find include directories and
#   libraries for Hdf5.
#
# Module usage:
#   find_package(SciHdf5 ...)
#
# This module will define the following variables:
#  HAVE_HDF5, HDF5_FOUND   = Whether libraries and includes are found
#  Hdf5_INCLUDE_DIRS       = Location of Hdf5 includes
#  Hdf5_LIBRARY_DIRS       = Location of Hdf5 libraries
#  Hdf5_LIBRARIES          = Required libraries
#  Hdf5_DLLS               =

######################################################################
#
# FindHdf5: find includes and libraries for hdf5
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

# This could be put into SciFindPackage
if (ENABLE_PARALLEL)
  if (USE_SHARED_LIBS OR USE_SHARED_HDF5)
    set(instdirs hdf5-parsh)
  else ()
    set(instdirs hdf5-par hdf5-ben)
  endif ()
else ()
  if (USE_CC4PY_LIBS OR USE_CC4PY_HDF5)
    set(instdirs hdf5-cc4py hdf5-sersh)
    if (WIN32)
      set(instdirs ${instdirs} hdf5-sermd)
    else ()
      set(instdirs ${instdirs} hdf5)
    endif ()
  elseif (USE_SHARED_LIBS OR USE_SHARED_HDF5)
    set(instdirs hdf5-sersh)
    if (WIN32)
      set(instdirs ${instdirs} hdf5-sermd)
    else ()
      set(instdirs ${instdirs} hdf5)
    endif ()
  else ()
    set(instdirs hdf5)
  endif ()
endif ()

if (WIN32)
# hdf5 keeps changing the name of its libraries on Windows, so at first we
# do not look for the libraries.  Once we find the installation, we then
# add the libs
  SciFindPackage(PACKAGE "Hdf5"
    INSTALL_DIRS ${instdirs}
    HEADERS hdf5.h
    INCLUDE_SUBDIRS include include/hdf5/include # Last for VisIt installation
    FIND_QUIETLY
  )
# Get the libraries
  get_filename_component(Hdf5_ROOT_DIR ${Hdf5_hdf5_h_INCLUDE_DIR}/.. REALPATH)
  if (DEBUG_CMAKE)
    message(STATUS "Hdf5_ROOT_DIR = ${Hdf5_ROOT_DIR}.")
  endif ()
  file(GLOB hlibs ${Hdf5_ROOT_DIR}/lib/hdf5*)
  if (DEBUG_CMAKE)
    message(STATUS "hlibs = ${hlibs}.")
  endif ()
  set(desiredlibs)
  foreach (lb ${hlibs})
    get_filename_component(ln ${lb} NAME_WE)
    set(desiredlibs ${desiredlibs} ${ln})
  endforeach ()
  file(GLOB hexecs ${Hdf5_ROOT_DIR}/bin/h5diff*.exe)
  set(desiredexecs)
  foreach (ex ${hexecs})
    get_filename_component(en ${ex} NAME_WE)
    set(desiredexecs ${desiredexecs} ${en})
  endforeach ()
else ()
  set(desiredlibs hdf5_hl hdf5)
  set(desiredexecs h5diff)
  if (CMAKE_Fortran_COMPILER_WORKS)
    set(desiredlibs hdf5_fortran hdf5_f90cstub ${desiredlibs})
  endif ()
endif ()
if (DEBUG_CMAKE)
  message(STATUS "Looking for the HDF5 libraries, ${desiredlibs}.")
endif ()

set(desiredmods)
if (CMAKE_Fortran_COMPILER_WORKS)
  set(desiredmods hdf5)
endif ()
SciFindPackage(PACKAGE "Hdf5"
  INSTALL_DIRS ${instdirs}
  EXECUTABLES ${desiredexecs}
  HEADERS hdf5.h
  LIBRARIES ${desiredlibs}
  MODULES ${desiredmods}
  INCLUDE_SUBDIRS include include/hdf5/include # Last for VisIt installation
  MODULE_SUBDIRS include/fortran include lib
)

# The executables are not always found, so we will hdf5 to found
# if includes and libraries found.
if (NOT HDF5_FOUND)
  if (Hdf5_hdf5_h AND Hdf5_hdf5_LIBRARY AND Hdf5_hdf5_hl_LIBRARY)
    set(HDF5_FOUND TRUE)
    message(STATUS "Setting HDF5_FOUND to TRUE because header and libraries found.")
  endif ()
endif ()

if (HDF5_FOUND)
  # message(STATUS "Found Hdf5")
  set(HAVE_HDF5 1 CACHE BOOL "Whether have the HDF5 library")
  set(OLD_H5S_SELECT_HYPERSLAB_IFC 0 CACHE BOOL
    "Whether using the old 1.6.3 H5Sselect_hyperslab interface")
  if (WIN32 AND Hdf5_DLLS)
    set(Hdf5_DEFINITIONS ${Hdf5_DEFINITIONS} -DH5_BUILT_AS_DYNAMIC_LIB)
    message(STATUS "Adding to Hdf5_DEFINITIONS that H5 build dynamic.")
    SciPrintVar(Hdf5_DEFINITIONS)
  endif ()
else ()
  message(STATUS "Did not find Hdf5.  Use -DHdf5_ROOT_DIR to specify the installation directory.")
  if (SciHdf5_FIND_REQUIRED)
    message(FATAL_ERROR "Failing.")
  endif ()
endif ()

