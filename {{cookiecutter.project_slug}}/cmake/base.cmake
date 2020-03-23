include_guard()

# Enable compile database for tools that rely on it.
# This creates a build/compile_commands.json that informs tools such as
# autocomplete or linter of compiler settings for each file.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Set a default build type if none was provided.
if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "No build type specified. Defaulting to Debug.")
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type." FORCE)
    set_property(
        CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
            "Debug"
            "Release"
            "MinSizeRel"
            "RelWithDebInfo"
        FORCE
    )
endif()

include(cmake/ccache.cmake)
include(cmake/static_analyzers.cmake)
