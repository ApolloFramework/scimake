######################################################################
#
# SciMultiArchKernels: Capabilities for building multiarch libraries
#
# $Id$
#
# Copyright 2010-2015, Tech-X Corporation, Boulder, CO.
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
#
######################################################################

message("")
message(STATUS "--------- Setting up multi-arch capabilities ---------")

######################################################################
# Define the set of architectures we're building for
######################################################################
set(ALL_INSTRUCTION_SETS Generic SSE2 SSE3 AVX AVX2 AVX512)
option(SCI_BUILD_ALL_INSTRUCTION_SETS
       "Whether to build for all architectures"
       FALSE)
if (SCI_BUILD_ALL_INSTRUCTION_SETS)
  SciPrintString("Building multiarch kernels for maximal set of ISAs")
  set(SCI_MULTIARCH_INSTRUCTION_SETS Generic)
  foreach(instSet ${ALL_INSTRUCTION_SETS})
    if (${instSet}_COMPILES)
      list(APPEND SCI_MULTIARCH_INSTRUCTION_SETS ${instSet})
    endif()
  endforeach()
else ()
  SciPrintString("Building multiarch kernels for minimal set of ISAs")
  set(SCI_MULTIARCH_INSTRUCTION_SETS Generic ${SCI_MOST_POWERFUL_ISA})
endif ()
SciPrintVar(SCI_MULTIARCH_INSTRUCTION_SETS)

# We use the SCI_MULTI_ARCH_cmp_FLAGS variables to construct compiler
# flags for the multi-architecture libraries.  We start from the FULL
# flags and remove all architecture specific flags.  The architecture
# specific flags are later put back one by one in a controlled way for
# each supported architecture.
foreach(cmp C CXX)
  set(SCI_MULTI_ARCH_${cmp}_FLAGS ${CMAKE_${cmp}_FLAGS_FULL})
  foreach(instSet ${ALL_INSTRUCTION_SETS})
    string(REPLACE "${${instSet}_FLAG}" ""
           SCI_MULTI_ARCH_${cmp}_FLAGS
           ${SCI_MULTI_ARCH_${cmp}_FLAGS})
  endforeach()
  SciPrintVar(SCI_MULTI_ARCH_${cmp}_FLAGS)
endforeach()

