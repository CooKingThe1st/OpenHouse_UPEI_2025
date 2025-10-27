cmake_minimum_required(VERSION 3.0)
project(controlPin)

set(CMAKE_CXX_STANDARD 17)
find_library(WIRINGPI_LIBRARIES NAMES wiringPi)



include_directories(${PROJECT_SOURCE_DIR})

add_executable(controlPin Source.cpp)
target_link_libraries(controlPin ${WIRINGPI_LIBRARIES})

