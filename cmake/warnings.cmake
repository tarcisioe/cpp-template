# Give the user an option to disable treating warnings as errors.
option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors." ON)

set(CLANG_BASE_WARNINGS
    -Wall
    -Wextra
    -Wpedantic
    # Keep sorted after this point
    -Wconversion
    -Wdouble-promotion
    -Wformat=2
    -Wnon-virtual-dtor
    -Wnull-dereference
    -Wold-style-cast
    -Woverloaded-virtual
    -Wshadow
    -Wsign-conversion
    -Wunused
)

set(GCC_BASE_WARNINGS
    ${CLANG_BASE_WARNINGS}
    -Wduplicated-branches
    -Wduplicated-cond
    -Wlogical-op
    -Wmisleading-indentation
    -Wuseless-cast
)

function(set_target_warnings target)
    # Set warnings for a target
    #
    # Args:
    #     target: The target to set the warnings on.
    # Keyword args:
    #     UNKNOWN_MESSAGE: A message to print as a warning if the compiler is unknown.
    #     MSVC: The list of MSVC warning flags to set.
    #     CLANG: The list of Clang warning flags to set.
    #     GCC: The list of GCC warning flags to set.

    # Parse keyword arguments
    cmake_parse_arguments(
        PARSE_ARGV
            1
        WARNINGS
        ""
        "TARGET;UNKNOWN_MESSAGE"
        "MSVC;CLANG;GCC"
    )

    if(MSVC)
        set(warnings ${WARNINGS_MSVC})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(warnings ${WARNINGS_CLANG})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(warnings ${WARNINGS_GCC})
    else()
        # Unknown compiler, warn user.
        message(WARNING "${UNKNOWN_MESSAGE}")
    endif()

    target_compile_options(
        ${target}
            INTERFACE
                ${warnings}
    )
endfunction()

function(set_target_base_warnings target)
    # TODO: Define MSVC warning list. For now, we warn.
    if(MSVC)
        message(WARNING "MSVC warnings are not being set yet.")
    endif()

    # Set the base warnings as defined in the constants.
    set_target_warnings(
        ${target}
            MSVC
                ""
            CLANG
                ${CLANG_BASE_WARNINGS}
            GCC
                ${GCC_BASE_WARNINGS}
            UNKNOWN_MESSAGE
                "Compiler is not known, cannot set warnings."
    )

    # Set the warnings-as-errors flag depending on the compiler.
    if(WARNINGS_AS_ERRORS)
        set_target_warnings(
            ${target}
                MSVC
                    "/WX"
                CLANG
                    "-Werror"
                GCC
                    "-Werror"
                UNKNOWN_MESSAGE
                    "Compiler is not known, cannot set warnings as errors."
        )
    endif()
endfunction()
