# - FindSciIdl: Module to find the IDL executable.
#
# Module usage:
#   find_package(SciIdl ...)
#
# Should probably be modified to use SciFindPackage...

######################################################################
#
# FindSciIdl.cmake: Find the IDL executable
#
# $Id: FindSciIdl.cmake 1245 2012-01-31 21:36:22Z dws $
#
# Copyright 2010-2012 Tech-X Corporation.
# Arbitrary redistribution allowed provided this copyright remains.
#
######################################################################

# convenience variable for ITT's install dir, should be fixed to use 
# Program Files env var but it is problematic in cygwin
if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(_Idl_PROGRAM_FILES_DIR "C:/Program Files")
  set(_Idl_NAME "IDL")
  set(_Idl_OS "")
  set(_Idl_KNOWN_COMPANIES "ITT" "Exelis")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(_Idl_PROGRAM_FILES_DIR "/Applications")
  set(_Idl_NAME "idl")
  set(_Idl_OS ".darwin")
  set(_Idl_KNOWN_COMPANIES "itt" "exelis")
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(_Idl_PROGRAM_FILES_DIR "/usr/local")
  set(_Idl_NAME "idl")
  set(_Idl_OS ".linux")
  set(_Idl_KNOWN_COMPANIES "itt" "exelis")
endif ()

# find idl based on version numbers, if you want a specific one, set
# it prior to running configure
if (NOT DEFINED Idl_FIND_VERSION)
  set(_Idl_KNOWN_VERSIONS "82" "81" "80" "71" "706")
# IDL 8.0 is in a different location than other versions on Windows (extra IDL directory in path)
  foreach (_Idl_COMPANY ${_Idl_KNOWN_COMPANIES})
    list(APPEND 
         _Idl_SEARCH_DIRS 
         "${_Idl_PROGRAM_FILES_DIR}/${_Idl_COMPANY}/${_Idl_NAME}/${_Idl_NAME}80")
    list(APPEND 
         _Idl_SEARCH_DIRS 
         "${_Idl_PROGRAM_FILES_DIR}/${_Idl_COMPANY}/${_Idl_NAME}/${_Idl_NAME}81")
    foreach (_Idl_KNOWN_VERSION ${_Idl_KNOWN_VERSIONS})
      list(APPEND _Idl_SEARCH_DIRS
           "${_Idl_PROGRAM_FILES_DIR}/${_Idl_COMPANY}/${_Idl_NAME}${_Idl_KNOWN_VERSION}")
    endforeach (_Idl_KNOWN_VERSION ${_Idl_KNOWN_VERSIONS})
  endforeach (_Idl_COMPANY ${_Idl_KNOWN_COMPANIES})
endif ()

if (NOT "$ENV{IDL_DIR}" STREQUAL "")
  set(_Idl_SEARCH_DIRS "$ENV{IDL_DIR}")
endif ()


find_path(Idl_INCLUDE_DIR
  idl_export.h
  PATHS ${_Idl_SEARCH_DIRS}
  HINTS ${IDL_ROOT}
  PATH_SUFFIXES external/include
)

find_library(Idl_LIBRARY
  NAMES idl
  PATHS ${_Idl_SEARCH_DIRS}
  HINTS ${IDL_ROOT}
  PATH_SUFFIXES /bin/bin${_Idl_OS}.x86_64 /bin/bin${_Idl_OS}.x86
)

if (Idl_INCLUDE_DIR AND Idl_LIBRARY)
  set(IDL_FOUND TRUE)
endif ()

if (IDL_FOUND)
  if (NOT SciIdl_FIND_QUIETLY)
    message(STATUS "Found IDL: ${Idl_LIBRARY}")
  endif ()
  set(HAVE_IDL 1 CACHE BOOL "Whether have IDL")
else ()
   if (SciIdl_FIND_REQUIRED)
      message(FATAL_ERROR "Did not find IDL. Use -DIdl_INCLUDE_DIR and -DIdl_LIBRARY to specify IDL locatin.")
   endif ()
endif ()

