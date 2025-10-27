cmake_minimum_required(VERSION 3.0)
project(Data_collection)

set(CMAKE_CXX_STANDARD 17)
find_package(OpenCV REQUIRED)


include_directories(${OpenCV_INCLUDE_DIRS})
include_directories(${PROJECT_SOURCE_DIR})

add_executable(Data_collection Source.cpp library.cpp)
target_link_libraries(Data_collection ${OpenCV_LIBS})

