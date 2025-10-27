cmake_minimum_required(VERSION 3.0)
project(Ras_normal_run)

set(CMAKE_CXX_STANDARD 17)
set(THREADS_PREDER_PTHREAD_FLAG TRUE)
find_package(Threads REQUIRED)
find_package(OpenCV REQUIRED)
find_library(WIRINGPI_LIBRARIES NAMES wiringPi)

include_directories(${OpenCV_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR})

add_executable(Ras_normal_run Source.cpp library.cpp)
target_link_libraries(Ras_normal_run ${OpenCV_LIBS} ${WIRINGPI_LIBRARIES} Threads::Threads)

