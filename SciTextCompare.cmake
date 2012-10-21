######################################################################
#
# SciTextCompare: Run an executable and check for differences between
#                 current and accepted results.
#
# $Id$
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
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
foreach (res ${TEST_RESULTS})
  execute_process(COMMAND ${CMAKE_COMMAND} -E compare_files
    ${res} ${TEST_RESULTS_DIR}/${res}
    RESULT_VARIABLE DIFFERS)
  if(DIFFERS)
    set(diffres ${diffres} "${res}")
  endif()
endforeach ()
if (diffres)
  message(FATAL_ERROR "Comparison failure: ${diffres} differ.")
endif ()
message(STATUS "Comparison succeeded.")

