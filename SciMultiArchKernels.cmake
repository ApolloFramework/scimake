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
SciPrintString("SCI_MULTIARCH_INSTRUCTION_SETS == ${SCI_MULTIARCH_INSTRUCTION_SETS}")
message(STATUS "------------------------------------------------------")
