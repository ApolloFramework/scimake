# - FindSciMagma: Module to find the MAGMA library.
#
# Module usage:
#   find_package(SciMagma ...)
#
# Should probably be modified to use SciFindPackage...

######################################################################
#
# FindSciMagma.cmake: Find the MAGMA library.
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

find_path(Magma_INCLUDE_DIR
  magma.h
  HINTS ${MAGMA_ROOT}
  PATH_SUFFIXES include
  DOC "MAGMA include directory"
)

find_library(Magma_LIBRARY
  NAMES magma
  HINTS ${MAGMA_ROOT}
  PATH_SUFFIXES lib
  DOC "MAGMA library location"
)

find_library(MagmaBlas_LIBRARY
  NAMES magmablas
  PATHS ${_Magma_SEARCH_DIRS}
  HINTS ${MAGMA_ROOT}
  PATH_SUFFIXES lib
  DOC "MAGMA BLAS library location"
)

if (Magma_INCLUDE_DIR AND Magma_LIBRARY AND MagmaBlas_LIBRARY)
  set(MAGMA_FOUND TRUE)
endif ()

if (MAGMA_FOUND)
  if (NOT SciMagma_FIND_QUIETLY)
    message(STATUS "Found MAGMA: ${Magma_LIBRARY}")
  endif ()
  set(HAVE_MAGMA 1 CACHE BOOL "Whether have MAGMA")
else ()
   if (SciMagma_FIND_REQUIRED)
     message(FATAL_ERROR "Could not find MAGMA")
   else ()
     if (MAGMA_ROOT)
       message(STATUS "MAGMA not found in ${MAGMA_ROOT}")
     else ()
       message(STATUS "Not searching for MAGMA")
     endif ()
   endif ()
endif ()

