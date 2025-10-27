cmake_minimum_required(VERSION 3.0)
project(Serial)

set(CMAKE_CXX_STANDARD 17)
find_library(WIRINGPI_LIBRARIES NAMES wiringPi)



include_directories(${PROJECT_SOURCE_DIR})

add_executable(Serial SerialTest.cpp)
target_link_libraries(Serial ${WIRINGPI_LIBRARIES})

