cmake_minimum_required(VERSION 3.11)
project(csv2tex CXX)
include(ExternalProject)

ExternalProject_Add(cxxopts
    GIT_REPOSITORY "https://github.com/jarro2783/cxxopts"
    GIT_TAG v2.2.0
    GIT_SHALLOW ON
    GIT_PROGRESS ON
    UPDATE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
)

add_executable(csv2tex
    "csv2tex.cpp"
)

add_dependencies(csv2tex
    cxxopts
)

set_target_properties(csv2tex PROPERTIES
    CXX_STANDARD 11
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
)

target_include_directories(csv2tex PRIVATE
    "${CMAKE_CURRENT_BINARY_DIR}/cxxopts-prefix/src/cxxopts/include"
)
