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
if (NOT DEFINED SCI_STD_TYPES_INSTALL)
  set(SCI_STD_TYPES_INSTALL TRUE)
endif ()

macro(CreateStdTypeFile type)
endmacro()

# Create c++11 array
if (HAVE_ANY_ARRAY)
  message(STATUS "creating ${SCI_PACKAGE_PREFIX}_array.")
  set(SCI_INCLUDE ${ARRAY_INCLUDE})
  get_filename_component(SCI_INCLUDE_NAME ${ARRAY_INCLUDE} NAME)
  string(REPLACE "." "_" SCI_INCLUDE_NAME ${SCI_INCLUDE_NAME})
  string(TOUPPER ${SCI_INCLUDE_NAME} SCI_INCLUDE_NAME_UC)
  set(SCI_TYPE array)
  set(SCI_NAMESPACE ${ARRAY_NAMESPACE})
  configure_file(sci_type.in
    ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_array
    # ${CMAKE_CURRENT_BINARY_DIR}/sci_array
  )
  if (SCI_STD_TYPES_INSTALL)
    install(FILES
      ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_array
      # ${CMAKE_CURRENT_BINARY_DIR}/sci_array
      DESTINATION include
    )
  endif ()
endif ()

# Create c++11 shared_ptr
if (HAVE_ANY_SHARED_PTR)
  message(STATUS "creating ${SCI_PACKAGE_PREFIX}_memory.")
  set(SCI_INCLUDE ${SHARED_PTR_INCLUDE})
  set(SCI_TYPE shared_ptr)
  set(SCI_NAMESPACE ${SHARED_PTR_NAMESPACE})
  configure_file(sci_type.in
    ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_memory
  )
  set(instfiles ${instfiles}
    ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_memory
  )
endif ()

