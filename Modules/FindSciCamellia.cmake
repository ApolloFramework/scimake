# - FindSciCamellia: Module to find include directories and
#   libraries for Camellia.
#
# Module usage:
#   find_package(SciCamellia ...)
#
# Otherwise use SciFindPackage.
#
# In either case, the following variables get defined.
#
# Camellia_DIR          : root installation directory for Camellia
# Camellia_PROGRAMS     : any Camellia executables
# Camellia_FILES        : any other files
# Camellia_INCLUDE_DIRS : include directories needed for compiling C/C++
# Camellia_MODULE_DIRS  : include directories needed for compiling fortran
# Camellia_LIBFLAGS     : any flags (except rpath flags) needed for linking the
#                         camellia libraries
# Camellia_LIBRARY_DIRS : the directories containing the libraries
# Camellia_LIBRARY_NAMES: the base library names, no extensions, no prefix
# Camellia_LIBRARIES    : the full paths to the libraries
# Camellia_STLIBS       : the full paths to the static libs if found, otherwise
#                         the same as in the above variable
# Camellia_TPL_LIBRARIES: third-party libraries needed for linking to Camellia
# Camellia_SLU_LIBRARIES: libraries specific to SuperLU and SuperLU_Dist
#
# and separate those into
#
#  Camellia_LINALG_LIBRARIES: the blas and lapack libraries used by Camellia
#  Camellia_SYSTEM_LIBRARIES: any other system libraries needed to link Camellia

######################################################################
#
# FindSciCamellia: find includes and libraries for Camellia
#
# $Rev$ $Date$
#
# Copyright 2012-2017, Tech-X Corporation, Boulder, CO.
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

# First get the config file
SciFindPackage(PACKAGE "Camellia"
  INSTALL_DIR par
  FIND_CONFIG_FILE
  USE_CONFIG_FILE
  NOPRINT
  FIND_QUIETLY
)

# Cleanup and conform to scimake conventions
if (Camellia_INCLUDE_DIRS)
      get_filename_component(Camellia_INCLUDE_DIRS ${Camellia_INCLUDE_DIRS} REALPATH)
endif ()
if (Camellia_LIBRARY_DIRS)
      get_filename_component(Camellia_LIBRARY_DIRS ${Camellia_LIBRARY_DIRS} REALPATH)
endif ()
set(Camellia_LIBRARY_NAMES ${Camellia_LIBRARIES})
set(Camellia_LIBRARIES)
foreach (trilib ${Camellia_LIBRARY_NAMES})
      find_library(Camellia_${trilib}_LIBRARY ${trilib}
            PATHS ${Camellia_LIBRARY_DIRS}
    NO_DEFAULT_PATH
  )
  set(Camellia_LIBRARIES ${Camellia_LIBRARIES} ${Camellia_${trilib}_LIBRARY})
endforeach ()
SciGetStaticLibs("${Camellia_LIBRARIES}" Camellia_STLIBS)

# Print results
SciPrintCMakeResults(Camellia)

if (CAMELLIA_FOUND)
      # Should now have all standard variables plus Camellia_TPL_LIBRARIES

# Some options
option(HAVE_CAMELLIA "Camellia libraries" ON)

# Remove duplicates
if (Camellia_TPL_LIBRARIES)
      list(REVERSE Camellia_TPL_LIBRARIES)
      list(REMOVE_DUPLICATES Camellia_TPL_LIBRARIES)
      list(REVERSE Camellia_TPL_LIBRARIES)
  endif ()

# Separate the third-party libraries into various groups, as only
# some needed for linking
set(Camellia_LINALG_LIBRARIES)
set(Camellia_MPI_LIBRARIES)
set(Camellia_SLU_LIBRARIES)
set(Camellia_MUMPS_LIBRARIES)
set(Camellia_SYSTEM_LIBRARIES)
set(Camellia_WRAPPER_LIBRARIES)
set(Camellia_USE_VENDOR_LINALG)
foreach (lib ${Camellia_TPL_LIBRARIES})
    get_filename_component(libname ${lib} NAME_WE)
    if (${libname} MATCHES "blas$" OR ${libname} MATCHES "lapack$" OR
        ${libname} MATCHES "acml$" OR ${libname} MATCHES "mkl" OR
        ${libname} MATCHES "f2c$" OR ${libname} MATCHES "atlas$")
  set(Camellia_LINALG_LIBRARIES ${Camellia_LINALG_LIBRARIES} ${lib})
  list(REMOVE_ITEM Camellia_TPL_LIBRARIES ${lib})
      if (${libname} MATCHES "mkl")
            set(Camellia_USE_VENDOR_LINALG "mkl")
      endif()
      #set(Camellia_USE_VENDOR_LINALG ${Camellia_USE_VENDOR_LINALG} PARENT_SCOPE)
# Cray wrappers include these, but needed for serial build.
    elseif (${libname} MATCHES "sci_pgi" OR ${libname} MATCHES "sci_gnu" OR
        ${libname} MATCHES "sci_intel")
  set(Camellia_LINALG_LIBRARIES ${Camellia_LINALG_LIBRARIES} ${lib})
    elseif (${libname} MATCHES "superlu$" OR ${libname} MATCHES "superlu_dist$")
          set(Camellia_SLU_LIBRARIES ${Camellia_SLU_LIBRARIES} ${lib})
    elseif (${libname} MATCHES "HYPRE$")
          set(Camellia_HYPRE_LIBRARIES ${Camellia_HYPRE_LIBRARIES} ${lib})
    elseif (${libname} MATCHES ".*mumps.*" OR ${libname} MATCHES "libpord")
          set(Camellia_MUMPS_LIBRARIES ${Camellia_MUMPS_LIBRARIES} ${lib})
    elseif (${libname} MATCHES "libseq")
          set(Camellia_MUMPS_LIBRARIES ${Camellia_MUMPS_LIBRARIES} ${lib})
    elseif (${libname} MATCHES "msmpi$")
          set(Camellia_MPI_LIBRARIES ${Camellia_MPI_LIBRARIES} ${lib})
    else ()
          set(Camellia_SYSTEM_LIBRARIES ${Camellia_SYSTEM_LIBRARIES} ${lib})
    endif ()
  endforeach ()
