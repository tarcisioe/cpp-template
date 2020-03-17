# Give the user an option to disable treating warnings as errors.
option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors." ON)

set(CLANG_WARNINGS
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

set(GCC_WARNINGS
    ${CLANG_WARNINGS}
    -Wduplicated-branches
    -Wduplicated-cond
    -Wlogical-op
    -Wmisleading-indentation
    -Wuseless-cast
)

function(set_target_base_warnings target)
    set(WERROR "")

    if(WARNINGS_AS_ERRORS)
        if(MSVC)
            set(WERROR /WX)
        elseif(
            CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR
            CMAKE_CXX_COMPILER_ID STREQUAL "GNU"
        )
            set(WERROR -Werror)
        else()
            # Unknown compiler.
            message(WARNING "Compiler is not known, cannot set warnings as errors.")
        endif()
    endif()

    set(WARNINGS "")

    if(MSVC)
        # TODO: MSVC warnings are not implemented yet.
        set(WARNINGS "")
        message(WARNING "MSVC warnings are not set yet.")
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        set(WARNINGS ${CLANG_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(WARNINGS ${GCC_WARNINGS})
    else()
        # Unknown compiler.
        message(WARNING "Compiler is not known, cannot set warnings.")
    endif()

    target_compile_options(
        ${target}
            INTERFACE
                ${WARNINGS}
                ${WERROR}
    )
endfunction()
