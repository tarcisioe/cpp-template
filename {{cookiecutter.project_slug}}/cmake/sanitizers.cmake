include_guard()

option(SANITIZER_ADDRESS "Enable address sanitizer." FALSE)
option(SANITIZER_UB "Enable undefined behaviour sanitizer." FALSE)
option(SANITIZER_THREAD "Enable thread sanitizer." FALSE)

include(cmake/compilers.cmake)

function(enable_sanitizers target)
    # Enable sanitizers for a given target.
    #
    # Args:
    #     target: the target to enable sanitizers for.

    if(NOT (USING_GCC OR USING_CLANG))
        return()
    endif()

    # Collect enabled sanitizers
    set(sanitizer_list "")

    if(SANITIZER_ADDRESS)
        list(APPEND sanitizer_list "address")
    endif()

    if(SANITIZER_UB)
        list(APPEND sanitizer_list "undefined")
    endif()

    if(SANITIZER_THREAD)
        list(APPEND sanitizer_list "thread")
    endif()

    # Generate a proper value for the compiler flag
    list(JOIN sanitizer_list "," sanitizers)

    # Set options on the target.
    if(NOT "${sanitizers}" STREQUAL "")
        target_compile_options(
            ${target}
                INTERFACE
                    -fsanitize=${sanitizers}
        )
        target_link_libraries(
            ${target}
                INTERFACE
                    -fsanitize=${sanitizers}
        )
    endif()
endfunction()
