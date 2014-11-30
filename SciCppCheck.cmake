######################################################################
#
# SciCppCheck: Run cppcheck on a source directory.
#
# $Id$
#
# Copyright 2010-2014, Tech-X Corporation, Boulder, CO.
# See LICENSE file (EclipseLicense.txt) for conditions of use.
#
#
######################################################################

if (NOT SCIMAKE_DIR)
  set(SCIMAKE_DIR "${TEST_SCIMAKE_DIR}")
endif ()

# Execute cppcheck
execute_process(COMMAND ${Cppcheck_cppcheck} ${CPPCHECK_SOURCE_DIR}
  RESULT_VARIABLE EXEC_ERROR
  OUTPUT_FILE cppcheck.out
  ERROR_FILE cppcheck.err
)

# Make sure cppcheck succeeded
if (EXEC_ERROR)
  message(STATUS "EXEC_ERROR      = ${EXEC_ERROR}")
  message(STATUS "RESULT_VARIABLE = ${RESULT_VARIABLE}")
  message(FATAL_ERROR "Execution failure.")
endif ()
message(STATUS "Execution succeeded.")

# Look for error messages
file(STRINGS cppcheck.err CPPCHECK_ERRORS REGEX "(error)")
string(LENGTH "${CPPCHECK_ERRORS}" errlen)
if (errlen)
  message(STATUS "cppcheck failures:")
  string(REPLACE ";" "\n" CPPCHECK_ERRORS "${CPPCHECK_ERRORS}")
  message(FATAL_ERROR ${CPPCHECK_ERRORS})
endif ()

