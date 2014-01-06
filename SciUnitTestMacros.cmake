######################################################################
#
# SciUnitTestMacros: Macros for adding unit tests of various types.
#
# $Id$
#
# Copyright 2014 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
######################################################################

# Add a unit test
MACRO(add_unit_test)
  set(oneValArgs NAME COMMAND)
  set(multiValArgs SOURCES LIBS ARGS)
  cmake_parse_arguments(TEST "${opts}" "${oneValArgs}" "${multiValArgs}" ${ARGN})
  add_executable(${TEST_COMMAND} ${TEST_SOURCES})
  target_link_libraries(${TEST_COMMAND} ${TEST_LIBS})
  add_test(NAME ${TEST_NAME} COMMAND ${TEST_COMMAND} ${TEST_ARGS})
ENDMACRO()

# Add a unit test which generates output that needs to be compared against
# golden output.
MACRO(add_unit_test_with_comparison)
  set(oneValArgs NAME COMMAND RESULTS_DIR STDOUT)
  set(multiValArgs RESULTS_FILES SOURCES LIBS ARGS)
  cmake_parse_arguments(TEST "${opts}" "${oneValArgs}" "${multiValArgs}" ${ARGN})
  set(TEST_EXECUTABLE "${CMAKE_CURRENT_BINARY_DIR}/${TEST_COMMAND}")
  add_executable(${TEST_COMMAND} ${TEST_SOURCES})
  target_link_libraries(${TEST_COMMAND} ${TEST_LIBS})
  add_test(NAME ${TEST_NAME} COMMAND ${CMAKE_COMMAND}
      -DTEST_PROG:FILEPATH=${TEST_EXECUTABLE} 
      -DTEST_ARGS:STRING=${TEST_ARGS}
      -DTEST_STDOUT:STRING=${TEST_STDOUT}
      -DTEST_RESULTS:STRING=${TEST_RESULTS_FILES}
      -DTEST_RESULTS_DIR:PATH=${TEST_RESULTS_DIR}
      -P ${SCIMAKE_DIR}/SciTextCompare.cmake
  )
  set_tests_properties("${TEST_COMMAND}"
    PROPERTIES
    ATTACHED_FILES_ON_FAIL "${RESULTS_FILES}")
ENDMACRO()

