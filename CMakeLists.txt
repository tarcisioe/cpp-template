cmake_minimum_required(VERSION 3.15)

project(project_name CXX)

include(cmake/base.cmake)
include(cmake/project_options.cmake)
# include(cmake/conan.cmake)

add_executable(main)

target_sources(
    main
        PRIVATE
            main.cpp
)

target_link_libraries(
    main
        PRIVATE
            project_options
)
