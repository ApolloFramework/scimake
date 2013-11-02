######################################################################
#
# SciSseAvx: Determine sse and avx capabilities to processor and add
#            to appropriate flags.
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

message("")
message(STATUS "Analyzing vector capabilities:")

# Determine the processor and sse capabilities
if (EXISTS /proc/cpuinfo)
  message(STATUS "Working on LINUX.")
  if (DISABLE_CPUCHECK) # For BGP
    message(STATUS "CPU check disabled.")
  else ()
    execute_process(COMMAND cat /proc/cpuinfo
        COMMAND grep "model name"
        COMMAND head -1
        OUTPUT_VARIABLE SCIC_CPU
        OUTPUT_STRIP_TRAILING_WHITESPACE)
  # For Blue Gene
    if (SCIC_CPU)
      string(REGEX REPLACE "^.*: " "" SCIC_CPU ${SCIC_CPU})
      execute_process(COMMAND cat /proc/cpuinfo
          COMMAND grep "flags"
          COMMAND head -1
          OUTPUT_VARIABLE CPU_CAPABILITIES
          OUTPUT_STRIP_TRAILING_WHITESPACE)
    else ()
      execute_process(COMMAND cat /proc/cpuinfo
          COMMAND grep "^cpu"
          COMMAND head -1
          OUTPUT_VARIABLE SCIC_CPU
          OUTPUT_STRIP_TRAILING_WHITESPACE)
      if (SCIC_CPU)
        string(REGEX REPLACE "^.*: " "" SCIC_CPU ${SCIC_CPU})
        string(REGEX REPLACE "^.*, *" "" CPU_CAPABILITIES ${SCIC_CPU})
        string(REGEX REPLACE ",.*$" "" SCIC_CPU ${SCIC_CPU})
      endif ()
    endif ()
  endif ()
elseif (APPLE)
  execute_process(COMMAND sysctl -a machdep.cpu.brand_string
      OUTPUT_VARIABLE SCIC_CPU
      OUTPUT_STRIP_TRAILING_WHITESPACE)
  string(REGEX REPLACE "^.*: " "" SCIC_CPU "${SCIC_CPU}")
  execute_process(COMMAND sysctl -a machdep.cpu.features
      COMMAND head -1
      OUTPUT_VARIABLE CPU_CAPABILITIES
      OUTPUT_STRIP_TRAILING_WHITESPACE)
  string(REGEX REPLACE "^.*: *" "" CPU_CAPABILITIES "${CPU_CAPABILITIES}")
  # string(REGEX REPLACE "SSE" "sse" CPU_CAPABILITIES "${CPU_CAPABILITIES}")
  string(TOLOWER "${CPU_CAPABILITIES}" CPU_CAPABILITIES)
endif ()
message(STATUS "CPU = ${SCIC_CPU}.")
message(STATUS "CPU_CAPABILITIES = ${CPU_CAPABILITIES}.")

if (CPU_CAPABILITIES)
  separate_arguments(CPU_CAPABILITIES)
  # message(STATUS "CPU capabilities are ${CPU_CAPABILITIES}")
  foreach (cap ${CPU_CAPABILITIES})
    # MESSAGE("Examining ${cap}")
    if (${cap} MATCHES "^sse")
      list(APPEND SSE_CAPABILITIES ${cap})
    elseif (${cap} MATCHES "^avx")
      list(APPEND AVX_CAPABILITIES ${cap})
    endif ()
  endforeach ()
  foreach(cap SSE AVX)
    if (${cap}_CAPABILITIES)
      list(SORT ${cap}_CAPABILITIES)
      list(REVERSE ${cap}_CAPABILITIES)
      list(GET ${cap}_CAPABILITIES 0 ${cap}_CAPABILITY)
      string(REPLACE "_" "." ${cap}_CAPABILITY "${${cap}_CAPABILITY}")
    endif ()
  endforeach ()
endif ()

foreach(cap SSE AVX)
  message(STATUS "${cap} capabilities are ${${cap}_CAPABILITIES}")
  message(STATUS "${cap} capability is ${${cap}_CAPABILITY}")
endforeach ()

# Handy
include(CheckCSourceCompiles)
include(CheckCSourceRuns)

# Check whether have sse2.
message("Checking sse2 capabilities.")
set(CMAKE_REQUIRED_FLAGS_SAV "${CMAKE_REQUIRED_FLAGS}")
set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} ${SSE2_FLAG}")
message("SSE2_FLAG = ${SSE2_FLAG}.")
check_c_source_compiles(
"
#include <emmintrin.h>
int main(int argc, char** argv) {
  double a[2] = {1.0, 2.0};
  __m128d t = _mm_loadu_pd(a);
  return 0;
}
"
SSE2_COMPILES
)
SciPrintVar(SSE2_COMPILES)
if (SSE2_COMPILES)
  check_c_source_runs(
"
#include <emmintrin.h>
int main(int argc, char** argv) {
  double a[2] = {1.0, 2.0};
  __m128d t = _mm_loadu_pd(a);
  return 0;
}
"
  SSE2_RUNS
  )
endif ()
set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS_SAV}")
SciPrintVar(SSE2_RUNS)

# Check whether have avx.
message("Checking avx capabilities.")
set(CMAKE_REQUIRED_FLAGS_SAV "${CMAKE_REQUIRED_FLAGS}")
set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} ${AVX_FLAG}")
message("AVX_FLAG = ${AVX_FLAG}.")
check_c_source_compiles(
"
#include <immintrin.h>
int main(int argc, char** argv) {
  double a[4] = {1.0, 2.0, 3.0, 4.0};
  __m256d t = _mm256_loadu_pd(a);
  return 0;
}
"
AVX_COMPILES
)
SciPrintVar(AVX_COMPILES)
if (AVX_COMPILES)
  check_c_source_runs(
"
#include <immintrin.h>
int main(int argc, char** argv) {
  double a[4] = {1.0, 2.0, 3.0, 4.0};
  __m256d t = _mm256_loadu_pd(a);
  return 0;
}
"
  AVX_RUNS
  )
endif ()
set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS_SAV}")
SciPrintVar(AVX_RUNS)

if (USE_OPENMP AND OPENMP_FLAG)
  set(HAVE_OPENMP TRUE)
  foreach (cmp C CXX)
    foreach (bld FULL RELEASE RELWITHDEBINFO MINSIZEREL)
      set(CMAKE_${cmp}_FLAGS_${bld} "${CMAKE_${cmp}_FLAGS_${bld}} ${OPENMP_FLAG}")
    endforeach ()
  endforeach ()
endif ()

# If we do runtime detection, we can add these flags more liberally
if (SSE2_COMPILES)
  set(SSE2_BUILDS FULL RELEASE RELWITHDEBINFO MINSIZEREL)
  if (ALLOW_SSE2)
    set(SSE2_BUILDS ${SSE2_BUILDS} ${CMAKE_BUILD_TYPE_UC})
  endif ()
  list(REMOVE_DUPLICATES SSE2_BUILDS)
  list(FIND SSE2_BUILDS ${CMAKE_BUILD_TYPE_UC} sse2found)
  if (NOT ${sse2found} EQUAL -1)
    set(HAVE_SSE2 TRUE)
  endif ()
  foreach (cmp C CXX)
    foreach (bld ${SSE2_BUILDS})
      set(CMAKE_${cmp}_FLAGS_${bld} "${CMAKE_${cmp}_FLAGS_${bld}} ${SSE2_FLAG}")
    endforeach ()
  endforeach ()
endif ()
if (AVX_RUNS)
  set(AVX_BUILDS FULL)
  if (ALLOW_AVX)
    set(AVX_BUILDS ${AVX_BUILDS} ${CMAKE_BUILD_TYPE_UC})
  endif ()
  list(REMOVE_DUPLICATES AVX_BUILDS)
  list(FIND AVX_BUILDS ${CMAKE_BUILD_TYPE_UC} avxfound)
  if (NOT ${avxfound} EQUAL -1)
    set(HAVE_AVX TRUE)
  endif ()
  foreach (cmp C CXX)
    foreach (bld ${AVX_BUILDS})
      set(CMAKE_${cmp}_FLAGS_${bld} "${CMAKE_${cmp}_FLAGS_${bld}} ${AVX_FLAG}")
    endforeach ()
  endforeach ()
endif ()

# Print results
message(STATUS "After analyzing vector capabilities:")
foreach (cmp C CXX)
  foreach (bld FULL RELEASE RELWITHDEBINFO MINSIZEREL DEBUG)
    SciPrintVar(CMAKE_${cmp}_FLAGS_${bld})
  endforeach ()
  SciPrintVar(CMAKE_${cmp}_FLAGS)
endforeach ()

