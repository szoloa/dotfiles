cmake_minimum_required(VERSION 3.10)
project(spine_example)

set(CMAKE_AUTOMOC ON)          # 开启自动 moc

find_package(Qt6 REQUIRED COMPONENTS Widgets)

file(GLOB_RECURSE SPINE_SOURCES "src/*.cpp")

# 将 SpineWidget.h 添加到源文件列表（假设它在 include/ 目录下）
add_executable(spine example.cpp ${SPINE_SOURCES} include/SpineWidget.h)

target_include_directories(spine PRIVATE include)
target_link_libraries(spine Qt6::Widgets)
