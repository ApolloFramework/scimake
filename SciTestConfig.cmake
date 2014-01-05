######################################################################
#
# SciTestConfig: Set variables for testing.
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

#
# enable_testing() and include(CTest) must be called before this is included.
#

set(CTEST_PROJECT_NAME "${CMAKE_PROJECT_NAME}")
set(CTEST_NIGHTLY_START_TIME "01:00:00 UTC")
set(SITE "${UQHOSTNAME}")
set(BUILDNAME "${CMAKE_SYSTEM}-${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_CXX_COMPILER_ID}${CMAKE_CXX_COMPILER_VERSION}")
if (BILDER_BUILD)
  set(BUILDNAME "${BUILDNAME}-${BILDER_BUILD}")
endif ()
SciPrintString("BILDER_BUILD = ${BILDER_BUILD}.")
SciPrintString("BUILDNAME = ${BUILDNAME}.")

set(CTEST_DROP_METHOD "http")
if (NOT CTEST_DROP_SITE AND (NOT "${CTEST_DROP_SITE}" STREQUAL NONE))
  set(CTEST_DROP_SITE "cdash.${DOMAINNAME}")
endif ()
SciPrintString("CTEST_DROP_SITE = ${CTEST_DROP_SITE}.")
set(CTEST_DROP_LOCATION "/submit.php?project=${CTEST_PROJECT_NAME}")
if (CTEST_DROP_SITE)
  set(CTEST_DROP_SITE_CDASH TRUE)
endif ()

option(ENABLE_COVERAGE "Enables compiling library for coverage data (only supported on gnu c++ compilers)." OFF)

if(ENABLE_COVERAGE)
  if((APPLE AND CMAKE_COMPILER_IS_CLANGXX)  # Apple's g++ doesn't support coverage data, but clang++ does
    OR (NOT APPLE AND CMAKE_COMPILER_IS_GNUCXX))
      # Enables coverage data
      set(CMAKE_CXX_FLAGS "-g -O0 -Wall -Wextra -fprofile-arcs -ftest-coverage")
      set(CMAKE_C_FLAGS "-g -O0 -Wall -Wextra -fprofile-arcs -ftest-coverage")
      set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -g -O0 -Wall -Wextra -fprofile-arcs -ftest-coverage")
      set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -g -O0 -Wall -Wextra -fprofile-arcs -ftest-coverage")
  endif()
endif()

