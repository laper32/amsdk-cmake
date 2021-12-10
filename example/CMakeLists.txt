# Modify By yourself!
project(Project)
cmake_minimum_required(VERSION 3.21)

set(CMAKE_CXX_STANDARD 20)

# Configurations
include(configure.cmake)
include(cmake/Initialize.cmake)
add_subdirectory(src)
