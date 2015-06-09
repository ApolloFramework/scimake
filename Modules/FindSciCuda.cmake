######################################################################
# - FindSciCuda: Find include directories and libraries for Cuda.
#
# Module usage:
#   find_package(SciCuda ...)
#
# This module will define the following variables:
#  HAVE_CUDA, CUDA_FOUND = Whether libraries and includes are found
#  CUDA_INCLUDE_DIRS       = Location of Cuda includes
#  CUDA_LIBRARY_DIRS       = Location of Cuda libraries
#  CUDA_LIBRARIES          = Required libraries
#
# Copyright 2013-2015, Tech-X Corporation, Boulder, CO.
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

message("")
message("--------- Looking for CUDA -----------")
find_package(CUDA 5.0)

string(FIND ${CMAKE_CXX_FLAGS} "-std=c++11" POS)
if (NOT ${POS} EQUAL -1)
  set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -std=c++11")
endif ()

# find_cuda_helper_libs(cusparse)
if (CUDA_CUDART_LIBRARY AND NOT CUDA_LIBRARY_DIRS)
  get_filename_component(CUDA_LIBRARY_DIRS ${CUDA_CUDART_LIBRARY}
    DIRECTORY CACHE
  )
endif ()

# The cuda library may not be in the frameworks area
find_library(CUDA_cuda_SHLIB cuda
  PATHS /usr/local/cuda-${CUDA_VERSION}
  PATH_SUFFIXES lib64 lib
  NO_DEFAULT_PATH
)
if (CUDA_cuda_SHLIB)
  get_filename_component(CUDA_cuda_SHLIB_DIR ${CUDA_cuda_SHLIB}
    DIRECTORY CACHE
  )
  set(CUDA_LIBRARY_DIRS ${CUDA_LIBRARY_DIRS} ${CUDA_cuda_SHLIB_DIR})
else ()
  set(CUDA_cuda_SHLIB ${CUDA_CUDA_LIBRARY})
endif ()

# Print results
foreach (sfx VERSION CUDA_LIBRARY cuda_SHLIB NVCC_EXECUTABLE
    TOOLKIT_ROOT_DIR TOOLKIT_INCLUDE INCLUDE_DIRS
    LIBRARY_DIRS LIBRARIES CUDART_LIBRARY
    curand_LIBRARY cublas_LIBRARY
    cusparse_LIBRARY cufft_LIBRARY npp_LIBRARY cupti_LIBRARY)
  SciPrintVar(CUDA_${sfx})
endforeach ()
if (CUDA_TOOLKIT_ROOT_DIR)
  set(HAVE_CUDA_TOOLKIT TRUE)
else ()
  set(HAVE_CUDA_TOOLKIT FALSE)
endif ()
SciPrintVar(HAVE_CUDA_TOOLKIT)
message("")

