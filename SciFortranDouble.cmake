######################################################################
#
# : Compute ntcc specific options
#
# $Id$
#
# Copyright 2010-2014, Tech-X Corporation, Boulder, CO.
# Arbitrary redistribution allowed provided this copyright remains.
#
#
######################################################################

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${FC_DOUBLE_FLAGS}")
# message(STATUS "CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")
message(STATUS "CMAKE_Fortran_FLAGS = ${CMAKE_Fortran_FLAGS}")

