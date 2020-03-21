include_guard()

option(ENABLE_CPPCHECK "Enable static analysis with cppcheck" OFF)
option(ENABLE_CLANG_TIDY "Enable static analysis with clang-tidy" OFF)

include(cmake/compilers.cmake)

macro(enable_program)
    # Enable a cmake-supported program to run during build, such as static
    # analysers.
    #
    # Keyword args:
    #     NAME: The name of the program
    #     VARIABLE: The CMake variable to populate with the program's executable
    #               path.
    #     CMAKE_VARIABLE: The CMake variable to populate with the full command
    #                     line for the program (e.g. CMAKE_CXX_CLANG_TIDY).
    #     FLAGS: A list of flags to be passed to the program.

    cmake_parse_arguments(
        PROGRAM
        ""
        "CMAKE_VARIABLE;NAME;VARIABLE"
        "FLAGS"
        ${ARGN}
    )

    find_program(${PROGRAM_VARIABLE} ${PROGRAM_NAME})

    if(${PROGRAM_VARIABLE})
        set(${PROGRAM_CMAKE_VARIABLE} ${${PROGRAM_VARIABLE}} ${PROGRAM_FLAGS})
    else()
        message(SEND_ERROR "${PROGRAM_NAME} requested but executable not found.")
    endif()
endmacro()


if(ENABLE_CPPCHECK)
    enable_program(
        NAME
            cppcheck
        VARIABLE
            CPPCHECK
        FLAGS
            --suppress=missingInclude --enable=all --inconclusive -i
        CMAKE_VARIABLE
            CMAKE_CXX_CPPCHECK
    )
endif()

if(ENABLE_CLANG_TIDY)
    if(NOT USING_CLANG)
        # Warnings conflict when we use clang-tidy with GCC (or MSVC, maybe).
        message(
            SEND_ERROR
            "clang-tidy can only be enabled when clang is the compiler."
        )
    else()
        enable_program(
            NAME
                clang-tidy
            VARIABLE
                CLANG_TIDY
            CMAKE_VARIABLE
                CMAKE_CXX_CLANG_TIDY
        )
    endif()
endif()
