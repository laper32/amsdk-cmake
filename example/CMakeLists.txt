# Modify By yourself!
project(Project)
cmake_minimum_required(VERSION 3.21)

set(CMAKE_CXX_STANDARD 20)

#set (__In $ENV{SOURCEMOD})
#message("${__In}")
#string(REPLACE "\\" "/" __In "${__In}")
#message("${__In}")

include(configure.cmake)
include(cmake/Configure.cmake)
add_subdirectory(src)
