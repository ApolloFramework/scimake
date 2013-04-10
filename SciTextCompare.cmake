######################################################################
#
# SciTextCompare: Run an executable and check for differences between
#                 current and accepted results.
#
# $Id$
#
# Copyright 2010-2013 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

# See whether program runs.
execute_process(COMMAND ${TEST_PROG} ${TEST_ARGS} RESULT_VARIABLE EXEC_ERROR)
if(EXEC_ERROR)
  message(FATAL_ERROR "Execution failure.")
endif()
message(STATUS "Execution succeeded.")

# Test all the output
set(diffres)
# There must be an easier way to pass a list
# message(STATUS "TEST_RESULTS = ${TEST_RESULTS}.")
string(REPLACE "\"" "" RESULTS_LIST "${TEST_RESULTS}")
string(REPLACE " " ";" RESULTS_LIST "${RESULTS_LIST}")
# message(STATUS "RESULTS_LIST = ${RESULTS_LIST}.")
foreach (res ${RESULTS_LIST})
  execute_process(COMMAND ${CMAKE_COMMAND} -E compare_files
    ${res} ${TEST_RESULTS_DIR}/${res}
    RESULT_VARIABLE DIFFERS)
  if (DIFFERS)
    set(diffres ${diffres} "${res}")
  else ()
    # if (VERBOSE)
      message(STATUS "Comparison of ${res} succeeded.")
    # endif()
  endif()
endforeach ()
if (diffres)
  message(FATAL_ERROR "Comparison failure: ${diffres} differ.")
endif ()
message(STATUS "Comparison succeeded.")

