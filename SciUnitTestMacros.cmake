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

# Add a unit test. If the test needs to compare its results against some
# expected results, then RESULTS_DIR and RESULTS (or STDOUT) must be set.
#
# Args
#   NAME        = the name of this test (which may or may not be the same
#                 as the executable)
#   COMMAND     = test executable (typically same as NAME, but need not be)
#   SOURCES     = 1+ source files to be compiled
#   LIBS        = libraries needed to link test
#   ARGS        = arguments to test
#   EXEC_DIRS   = directories to add to PATH when executing test
#   RESULTS     = Files to be compared against golden results. If this
#                 var is empty, no comparisons will be done (but see
#                 STDOUT below)
#   RESULTS_DIR = directory which contains expected results
#   STDOUT_FILE = Name of file into which stdout should be captured. This
#                 file will be added to $RESULTS so it will be compared
#                 against expected output.

MACRO(SciAddUnitTest)
  string(ASCII 1 WORKAROUND_SEPARATOR)
  set(oneValArgs NAME COMMAND RESULTS_DIR STDOUT_FILE)
  set(multiValArgs RESULTS_FILES SOURCES LIBS ARGS EXEC_DIRS)
  cmake_parse_arguments(TEST "${opts}" "${oneValArgs}" "${multiValArgs}"
      ${ARGN})
  set(TEST_EXECUTABLE "${CMAKE_CURRENT_BINARY_DIR}/${TEST_COMMAND}")
  add_executable(${TEST_COMMAND} ${TEST_SOURCES})
  target_link_libraries(${TEST_COMMAND} ${TEST_LIBS})

# Because we can't pass a list to cmake with -D option below, we have to
# convert the list into a string, meaning we have to get rid of the semi-
# colons in the string. If we were using CMake 2.8.11, we could convert the
# semicolons into the generator $<SEMICOLON>, but for now we need to use a
# workaround separator caharcter which isn't going to be contained in any of
# the strings that make up the list. We can be pretty certain the ctrl-A
# (ASCII 001) won't be in any of the strings.

  string(REPLACE ";" "${WORKAROUND_SEPARATOR}" EXEC_DIR_STRING
      "${TEST_EXEC_DIRS}")

  add_test(NAME ${TEST_NAME} COMMAND ${CMAKE_COMMAND}
      -DTEST_PROG:FILEPATH=${TEST_EXECUTABLE}
      -DTEST_ARGS:STRING=${TEST_ARGS}
      -DTEST_STDOUT_FILE:STRING=${TEST_STDOUT_FILE}
      -DTEST_RESULTS:STRING=${TEST_RESULTS_FILES}
      -DTEST_RESULTS_DIR:PATH=${TEST_RESULTS_DIR}
      -DTEST_EXEC_DIRS:STRING=${EXEC_DIR_STRING}
      -P ${SCIMAKE_DIR}/SciTextCompare.cmake
  )
  set_tests_properties("${TEST_COMMAND}"
    PROPERTIES ATTACHED_FILES_ON_FAIL "${RESULTS_FILES}")
ENDMACRO()

