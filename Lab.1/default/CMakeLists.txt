cmake_minimum_required(VERSION 3.0.0)
project(default VERSION 0.1.0)

add_executable(default lab1.cpp sha256.cpp)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
