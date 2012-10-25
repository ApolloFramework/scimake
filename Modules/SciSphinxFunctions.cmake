# - SciSphinxFunctions: 
# Usefule functions for simplifying the setting up of sphinx targets
#
# All functions assume that FindSciSphinx was used and the following are
# defined:
#   Sphinx_EXECUTABLE     = The path to the sphinx command.
#   Sphinx_OPTS           = Options for sphinx
#

#################################################################
#
# $Id: SciSphinxFunctions.cmake 64 2012-09-22 14:48:08Z jrobcary $
#
#################################################################

include(CMakeParseArguments)

# SciSphinxTarget.cmake
# Define the target for making HTML
# Args:
#   TARGET:  Name to make the target.  Actual target will be #   ${TARGET_NAME}-html
#   LATEX_ROOT:  Root name of Latex file.  From conf.py
#   SOURCE_DIR:  Directory containing the index.rst.  Defaults to CMAKE_CURRENT_SOURCE_DIR
#   SPHINX_ADDL_OPTS:  Additional options to Sphinx
#   FILE_DEPS:  Files that are the dependencies
#
macro(SciSphinxTarget)

# Parse out the args
  set(opts DEBUG) # no-value args
  set(oneValArgs LATEX_ROOT;TARGET;SPHINX_ADDL_OPTS;SOURCE_DIR)
  set(multValArgs FILE_DEPS) # e.g., lists
  cmake_parse_arguments(FD "${opts}" "${oneValArgs}" "${multValArgs}" ${ARGN})

  ###
  ## Defaults
  #
  if(NOT DEFINED FD_SOURCE_DIR)
    set(FD_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
  endif()
  ###
  ##  Basic idiot checks
  #
  if(NOT DEFINED FD_TARGET)
     message(WARNING "SciSphinxHtmlTarget called without specifying the target name")
     return()
  endif()
  if(NOT DEFINED FD_FILE_DEPS)
     message(WARNING "SciSphinxHtmlTarget called without specifying the file dependencies")
     return()
  endif()
  if(NOT DEFINED FD_LATEX_ROOT)
     message(WARNING "SciSphinxHtmlTarget called without specifying the latex root from conf.py")
     return()
  endif()
  if(NOT DEFINED Sphinx_EXECUTABLE)
     message(WARNING "SciSphinxHtmlTarget called without defining Sphinx_EXECUTABLE")
     return()
  endif()
  if (FD_DEBUG)
    message("")
    message("--------- SciSphinxHtmlTarget defining ${FD_TARGET}-html ---------")
    message(STATUS "[SciSphinxFunctions]: TARGET= ${FD_TARGET} ")
    message(STATUS "[SciSphinxFunctions]: LATEX_ROOT= ${FD_LATEX_ROOT} ")
    message(STATUS "[SciSphinxFunctions]: Sphinx_EXECUTABLE= ${Sphinx_EXECUTABLE} ")
    message(STATUS "[SciSphinxFunctions]: Sphinx_OPTS= ${Sphinx_OPTS} ")
    message(STATUS "[SciSphinxFunctions]: SPHINX_ADDL_OPTS= ${FD_SPHINX_ADDL_OPTS} ")
  endif()
  ###
  ##  Do the standard builds
  #
  set(html_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/html/index.html)
  set(singlehtml_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/singlehtml/index.html)
  set(latex_OUTPUT ${BLDDIR}/pdf/${FD_LATEX_ROOT}.tex)
  set(pdf_OUTPUT ${BLDDIR}/pdf/${FD_LATEX_ROOT}.pdf)
  set(man_OUTPUT ${BLDDIR}/man/index.man)

  foreach (build html latex singlehtml man)
    set (${build}_DIR ${CMAKE_CURRENT_BINARY_DIR}/${build})
    # Latex is actually for pdf which is below
    if(${build} STREQUAL latex)
      set (${build}_DIR ${CMAKE_CURRENT_BINARY_DIR}/pdf)
    endif()
    
    # There is something weird about passing blank spaces into COMMAND 
    # so this method fixes the problems that arise if Sphinx_OPTS is not defined
    set(all_opts -b ${build} ${Sphinx_OPTS} ${FD_SPHINX_ADDL_OPTS})
    message(STATUS "[SciSphinxFunctions]: all_opts= ${all_opts} ")

    add_custom_command(
      OUTPUT ${${build}_OUTPUT}
      COMMAND ${Sphinx_EXECUTABLE} ${all_opts} ${FD_SOURCE_DIR} ${${build}_DIR}
      DEPENDS ${FD_FILE_DEPS}
    )
    add_custom_target(${FD_TARGET}-${build} DEPENDS ${${build}_OUTPUT})
  endforeach()

  ###
  ##  PDF is special
  ##   This must be make, as sphinx generates a unix makefile
  #
  add_custom_command(
    OUTPUT ${pdf_OUTPUT}
    COMMAND make all-pdf
    DEPENDS ${latex_OUTPUT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/pdf
  )
  add_custom_target(${FD_TARGET}-pdf DEPENDS ${pdf_OUTPUT})

endmacro()

# Need to figure out a better way of automating install as well, but worry about it later.
if (0)
# We install the html files directly under learning_vorpal
install(
  DIRECTORY ${BLDDIR}/html/
  OPTIONAL
  DESTINATION ${USERDOCS_INSTALLDIR}/learning_vorpal
  COMPONENT userdocs
)

# This becomes a subdirectory because no trailing slash
install(
  DIRECTORY ${BLDDIR}/man
  OPTIONAL
  DESTINATION ${USERDOCS_INSTALLDIR}/learning_vorpal/
  COMPONENT userdocs
)
endif ()

