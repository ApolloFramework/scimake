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

if (CMAKE_BUILD_TYPE EQUAL Debug)
  list(APPEND CUDA_NVCC_FLAGS
      -g -G --use_fast_math --generate-code arch=compute_20,code=sm_20)
else ()
  list(APPEND CUDA_NVCC_FLAGS
      -O3
      --use_fast_math
      --ptxas-options=-v
      --generate-code arch=compute_20,code=sm_20
      --generate-code arch=compute_20,code=sm_21
      --generate-code arch=compute_30,code=sm_30
      --generate-code arch=compute_35,code=sm_35
      --generate-code arch=compute_50,code=sm_50
      --generate-code arch=compute_52,code=sm_52
      --generate-code arch=compute_52,code=compute_52
      )
endif ()

string(FIND ${CMAKE_CXX_FLAGS} "-std=c++11" POS)
if (NOT ${POS} EQUAL -1)
  list(APPEND CUDA_NVCC_FLAGS "-std=c++11")
endif ()

# find_cuda_helper_libs(cusparse)
if (CUDA_CUDART_LIBRARY AND NOT CUDA_LIBRARY_DIRS)
  get_filename_component(CUDA_LIBRARY_DIRS ${CUDA_CUDART_LIBRARY}
    DIRECTORY CACHE
  )
endif ()

# If building in parallel, need to set -ccbin option to the serial
# compiler on mac.
if (ENABLE_PARALLEL)
  execute_process(COMMAND ${CMAKE_C_COMPILER}
                  --showme:command OUTPUT_VARIABLE SERIAL_C_COMPILER
                  RESULT_VARIABLE SERIAL_C_COMPILER_RESULT)
  if (SERIAL_C_COMPILER_RESULT EQUAL 0)
    SciPrintVar(SERIAL_C_COMPILER)
    if (APPLE)
      list(APPEND CUDA_NVCC_FLAGS "-ccbin ${SERIAL_C_COMPILER}")
    endif()
  else()
    message(STATUS "Could not detect serial C compiler.")
  endif()
endif()

# If CMake version >= 2.8.11, need to add the CUDA library manually
if (${CMAKE_VERSION} VERSION_GREATER 2.8.10)
  if (CUDA_CUDA_LIBRARY)
    get_filename_component(CUDA_CUDA_DIR ${CUDA_CUDA_LIBRARY}/.. REALPATH)
    set(CUDA_LIBRARIES ${CUDA_LIBRARIES} ${CUDA_CUDA_LIBRARY})
    if (NOT WIN32)
      set(CUDA_LIBRARIES ${CUDA_LIBRARIES} "-Wl,-rpath -Wl,${CUDA_CUDA_DIR}")
    endif()
  else()
    message(WARNING "CUDA_CUDA_LIBRARY not found, so link may fail.")
  endif()
endif()

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
    NVCC_FLAGS TOOLKIT_ROOT_DIR TOOLKIT_INCLUDE INCLUDE_DIRS
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

