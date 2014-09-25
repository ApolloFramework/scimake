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
  string(TOUPPER ${type} typeuc)
  if (HAVE_ANY_${typeuc})
    message(STATUS "creating ${SCI_PACKAGE_PREFIX}_${type}.")
    set(SCI_INCLUDE ${${typeuc}_INCLUDE})
    get_filename_component(SCI_INCLUDE_NAME ${${typeuc}_INCLUDE} NAME)
    string(REPLACE "." "_" SCI_INCLUDE_NAME ${SCI_INCLUDE_NAME})
    string(TOUPPER ${SCI_INCLUDE_NAME} SCI_INCLUDE_NAME_UC)
    set(SCI_TYPE ${type})
    set(SCI_NAMESPACE ${${typeuc}_NAMESPACE})
    configure_file(sci_type.in
      ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_${type}
      # ${CMAKE_CURRENT_BINARY_DIR}/sci_${type}
    )
    if (SCI_STD_TYPES_INSTALL)
      install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/${SCI_PACKAGE_PREFIX}_${type}
        # ${CMAKE_CURRENT_BINARY_DIR}/sci_${type}
        DESTINATION include
      )
    endif ()
  endif ()
endmacro()

# Create c++11 files
CreateStdTypeFile(array)
CreateStdTypeFile(shared_ptr)

