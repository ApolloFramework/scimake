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

string(TOUPPER ${SCI_PACKAGE_PREFIX} SCI_PACKAGE_PREFIX_UC)
message(STATUS "SCI_PACKAGE_PREFIX_UC = ${SCI_PACKAGE_PREFIX_UC}")

# Create c++11 array
message(STATUS "creating ${SCI_PACKAGE_PREFIX}_array.")
set(SCI_INCLUDE ${ARRAY_INCLUDE})
set(SCI_TYPE array)
set(SCI_NAMESPACE ${ARRAY_NAMESPACE})
configure_file(sci_type.in
  ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_array)

# Create c++11 shared_ptr
message(STATUS "creating ${SCI_PACKAGE_PREFIX}_memory.")
set(SCI_INCLUDE ${SHARED_PTR_INCLUDE})
set(SCI_TYPE shared_ptr)
set(SCI_NAMESPACE ${SHARED_PTR_NAMESPACE})
configure_file(sci_type.in
  ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_memory)

if (NOT DEFINED SCI_PACKAGE_INSTALL)
  set(SCI_PACKAGE_INSTALL TRUE)
endif ()
if (SCI_PACKAGE_INSTALL)
  install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_array
    ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_memory
    DESTINATION include
  )
endif ()

