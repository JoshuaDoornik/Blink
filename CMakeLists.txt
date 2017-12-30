cmake_minimum_required(VERSION 3.9)
project(blink_ C)

set(CMAKE_C_STANDARD 11)
find_package(PythonLibs REQUIRED)
include_directories(${PYTHON_INCLUDE_DIRS})
add_executable(blink_ main.c)