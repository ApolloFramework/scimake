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

string(REPLACE "\"" "" ARGS_LIST "${TEST_ARGS}")
string(REPLACE " " ";" ARGS_LIST "${ARGS_LIST}")

# if TEST_STDOUT_FILE is non-empty, then we use it as the output file
# into for the execute_process(), and we add it to the ${TEST_RESULTS}
# to be compared. This allows us to have a test which generates one or
# more files which are to be compared, while also comparing the stdout
# of the test.

if (TEST_STDOUT_FILE)
  execute_process(COMMAND ${TEST_PROG} ${ARGS_LIST} 
    RESULT_VARIABLE EXEC_ERROR
    OUTPUT_FILE ${TEST_STDOUT_FILE})
  set(TEST_RESULTS ${TEST_RESULTS} ${TEST_STDOUT_FILE})
else ()
  execute_process(COMMAND ${TEST_PROG} ${ARGS_LIST}
    RESULT_VARIABLE EXEC_ERROR)
endif ()

if (EXEC_ERROR)
  message(FATAL_ERROR "Execution failure.")
endif ()
message(STATUS "Execution succeeded.")

if (TEST_RESULTS)
  # Test all the output
  # There must be an easier way to pass a list
  # message(STATUS "TEST_RESULTS = ${TEST_RESULTS}.")
  string(REPLACE "\"" "" RESULTS_LIST "${TEST_RESULTS}")
  string(REPLACE " " ";" RESULTS_LIST "${RESULTS_LIST}")
  message(STATUS "RESULTS_LIST = ${RESULTS_LIST}.")

  foreach (res ${RESULTS_LIST})
    if (NOT EXISTS ${res}) 
      message(FATAL_ERROR "FILE ${res} does not exist.")
    endif()
    if (NOT EXISTS ${TEST_RESULTS_DIR}/${res}) 
      message(FATAL_ERROR "FILE ${TEST_RESULTS_DIR}/${res} does not exist.")
    endif()
    execute_process(COMMAND diff --strip-trailing-cr
      ${res} ${TEST_RESULTS_DIR}/${res}
      RESULT_VARIABLE DIFFERS)
    if (DIFFERS)
      set(diffres "${res}")
    else ()
      message(STATUS "Comparison of ${res} succeeded.")
    endif()
  endforeach ()
  if (diffres)
    message(FATAL_ERROR "Comparison failure: ${diffres} differ.")
  endif ()
  message(STATUS "Comparison succeeded.")
endif ()
