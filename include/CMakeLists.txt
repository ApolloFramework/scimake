######################################################################
#
# CMakeLists.txt for scimake/include
#
# $Id$
#
# Copyright &copy; 2005-2013 Tech-X Corporation, Boulder, CO
# See LICENSE file for conditions of use.
#
######################################################################

message(STATUS "Configuring sci_array.in.")
string(TOUPPER ${SCI_ARRAY_PREFIX} SCI_ARRAY_PREFIX_UC)
configure_file(sci_array.in
  ${CMAKE_CURRENT_BINARY_DIR}/${SCI_ARRAY_PREFIX}_array)
if (NOT DEFINED SCI_ARRAY_INSTALL)
  set(SCI_ARRAY_INSTALL TRUE)
endif ()
if (SCI_ARRAY_INSTALL)
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${SCI_ARRAY_PREFIX}_array
      DESTINATION include)
endif ()

