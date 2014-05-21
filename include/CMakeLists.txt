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
configure_file(sci_array.in ${CMAKE_CURRENT_BINARY_DIR}/${ARRAY_PREFIX}_array)

