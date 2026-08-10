cmake_minimum_required(VERSION 3.16)
project(SpineQmlModule VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_AUTOMOC ON)

# Qt6
find_package(Qt6 REQUIRED COMPONENTS Quick OpenGL)

# Spine C++ Runtime sources
file(GLOB spine_sources "spine/src/spine/*.cpp")

# QML module dev output (next to shell.qml, needs QML_IMPORT_PATH to use)
set(QML_DEV_DIR "${CMAKE_CURRENT_SOURCE_DIR}/SpineQml")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${QML_DEV_DIR}")

# QML Module
qt_add_qml_module(${PROJECT_NAME}
    URI "SpineQml"
    VERSION 1.0
    NO_PLUGIN_OPTIONAL
    SOURCES
        spineqml/spineitem.h
        spineqml/spineitem.cpp
        spineqml/filewatcher.h
        ${spine_sources}
    QML_FILES
        shell.qml
)

# Include paths
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/spine/include
    ${CMAKE_CURRENT_SOURCE_DIR}/spineqml
)

# Link
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Quick
    Qt6::OpenGL
)

# Post-build: collect all module files into local SpineQml/ dir
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "${QML_DEV_DIR}"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CMAKE_BINARY_DIR}/qmldir" "${QML_DEV_DIR}/qmldir"
    COMMAND sed -i "/^prefer /d" "${QML_DEV_DIR}/qmldir"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CMAKE_BINARY_DIR}/SpineQmlModule.qmltypes"
        "${QML_DEV_DIR}/SpineQmlModule.qmltypes"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CMAKE_BINARY_DIR}/libSpineQmlModuleplugin.so"
        "${QML_DEV_DIR}/libSpineQmlModuleplugin.so"
)

# Install to system QML path (no env var needed):
#   sudo cmake --install build
install(DIRECTORY "${QML_DEV_DIR}/"
    DESTINATION "/usr/lib/qt6/qml/SpineQml"
    FILES_MATCHING PATTERN "*.so" PATTERN "qmldir" PATTERN "*.qmltypes"
)
