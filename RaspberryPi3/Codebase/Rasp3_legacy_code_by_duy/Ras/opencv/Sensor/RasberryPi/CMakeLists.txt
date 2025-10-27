cmake_minimum_required(VERSION 3.0)
project(opencvTest)

set(CMAKE_CXX_STANDARD 17)
find_package(OpenCV REQUIRED)



include_directories(${OpenCV_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR})

add_executable(opencvTest Source.cpp library.cpp)
target_link_libraries(opencvTest ${OpenCV_LIBS} ${WIRINGPI_LIBRARIES})

