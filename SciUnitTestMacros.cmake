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

message("--------- Setting up testing ---------")

# Set test environment
if (WIN32)
  set(SHLIB_PATH_VAR PATH)
elseif (APPLE)
  set(SHLIB_PATH_VAR DYLD_LIBRARY_PATH)
elseif (LINUX)
  set(SHLIB_PATH_VAR LD_LIBRARY_PATH)
endif ()
message(STATUS "SHLIB_PATH_VAR = ${SHLIB_PATH_VAR}.")

file(TO_CMAKE_PATH "$ENV{${SHLIB_PATH_VAR}}" SHLIB_CMAKE_PATH_VAL)

message(STATUS "In SciAddUnitTestMacros.cmake, SHLIB_CMAKE_PATH_VAL = ${SHLIB_CMAKE_PATH_VAL}")

# make a macro for converting a cmake path into a platform specific path
macro(makeNativePath)
  set(oneValArgs OUTPATH)
  set(multiValArgs INPATH)
  cmake_parse_arguments(TO_NATIVE "${opts}" "${oneValArgs}" "${multiValArgs}" ${ARGN})
  file(TO_NATIVE_PATH "${TO_NATIVE_INPATH}" NATIVE_OUTPATH)
  if(WIN32)
    string(REPLACE ";" "\\;" ${TO_NATIVE_OUTPATH} "${NATIVE_OUTPATH}")
  else(WIN32)
    string(REPLACE ";" ":" ${TO_NATIVE_OUTPATH} "${NATIVE_OUTPATH}")
  endif(WIN32)
endmacro()

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
#   RESULTS     = Files to be compared against golden results. If this
#                 var is empty, no comparisons will be done (but see
#                 STDOUT below)
#   RESULTS_DIR = directory which contains expected results
#   STDOUT_FILE = Name of file into which stdout should be captured. This
#                 file will be added to $RESULTS so it will be compared
#                 against expected output.

macro(SciAddUnitTest)
  string(ASCII 1 WORKAROUND_SEPARATOR)
  set(oneValArgs NAME COMMAND RESULTS_DIR STDOUT_FILE)
  set(multiValArgs RESULTS_FILES SOURCES LIBS ARGS EXEC_DIRS)
  cmake_parse_arguments(TEST "${opts}" "${oneValArgs}" "${multiValArgs}" ${ARGN})
  set(TEST_EXECUTABLE "${CMAKE_CURRENT_BINARY_DIR}/${TEST_COMMAND}")
  add_executable(${TEST_COMMAND} ${TEST_SOURCES})
  target_link_libraries(${TEST_COMMAND} ${TEST_LIBS})
  add_test(NAME ${TEST_NAME} COMMAND ${CMAKE_COMMAND}
      -DTEST_PROG:FILEPATH=${TEST_EXECUTABLE} 
      -DTEST_ARGS:STRING=${TEST_ARGS}
      -DTEST_STDOUT_FILE:STRING=${TEST_STDOUT_FILE}
      -DTEST_RESULTS:STRING=${TEST_RESULTS_FILES}
      -DTEST_RESULTS_DIR:PATH=${TEST_RESULTS_DIR}
      -P ${SCIMAKE_DIR}/SciTextCompare.cmake
  )
# convert the cmake shared libraries path into a machine specific native path
  make_native_path(INPATH "${SHLIB_CMAKE_PATH_VAL}" OUTPATH TESTS_LIB_PATH)
  set_tests_properties("${TEST_COMMAND}"
    PROPERTIES ENVIRONMENT "${SHLIB_PATH_VAR}=${TESTS_LIB_PATH}"
    ATTACHED_FILES_ON_FAIL "${RESULTS_FILES}")
endmacro()

