include_guard()

option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors." ON)

include(cmake/compilers.cmake)

# Thanks @lefticus for the translation of the MSVC warnings, phew!
set(MSVC_BASE_WARNINGS
    # Baseline
    /W4

    # Keep sorted after this point
    /w14242  # 'identfier': conversion from 'type1' to 'type1', possible loss
             # of data
    /w14254  # 'operator': conversion from 'type1:field_bits' to
             # 'type2:field_bits', possible loss of data
    /w14263  # 'function': member function does not override any base class
             # virtual member function
    /w14265  # 'classname': class has virtual functions, but destructor is not
             # virtual instances of this class may not be destructed correctly
    /w14287  # 'operator': unsigned/negative constant mismatch
    /w14296  # 'operator': expression is always 'boolean_value'
    /w14311  # 'variable': pointer truncation from 'type1' to 'type2'
    /w14545  # expression before comma evaluates to a function which is missing
             # an argument list
    /w14546  # function call before comma missing argument list
    /w14547  # 'operator': operator before comma has no effect; expected
             # operator with side-effect
    /w14549  # 'operator': operator before comma has no effect; did you intend
             # 'operator'?
    /w14555  # expression has no effect; expected expression with side- effect
    /w14619  # pragma warning: there is no warning number 'number'
    /w14640  # Enable warning on thread un-safe static member initialization
    /w14826  # Conversion from 'type1' to 'type_2' is sign-extended. This may
             # cause unexpected runtime behavior.
    /w14905  # Wide string literal cast to 'LPSTR'
    /w14906  # String literal cast to 'LPWSTR'
    /w14928  # Illegal copy-initialization; more than one user-define conversion
             # has been implicitly applied
    /we4289  # nonstandard extension used: 'variable': loop control variable
             # declared in the for-loop is used outside the for-loop scope
)

set(CLANG_BASE_WARNINGS
    # Baseline
    -Wall
    -Wextra
    -Wpedantic  # Warn if non-standard C++ is used.

    # Keep sorted after this point
    -Wconversion  # Warn if type conversions may lose data.
    -Wdouble-promotion  # Warn if float is being implicitly promoted to double.
    -Wformat=2  # Warn on security issues on printf-like formatting functions.
    -Wnon-virtual-dtor  # Warn if a class with virtual member functions does not
                        # have a virtual destructor. No "always make destructors
                        # virtual"!
    -Wnull-dereference
    -Wold-style-cast  # Warn on C-style casts (e.g. (int)x).
    -Woverloaded-virtual  # Warn if a virtual function is overloaded.
    -Wshadow  # Warn if a declaration shadows something from an outer scope.
    -Wsign-conversion  # Warn on sign conversions.
    -Wunused  # Warn on unused symbols.
)

set(GCC_BASE_WARNINGS
    ${CLANG_BASE_WARNINGS}
    -Wduplicated-branches
    -Wduplicated-cond
    -Wlogical-op  # Warn if logical operations are being used where bitwise is
                  # likely wanted.
    -Wmisleading-indentation  # Warn if indentation implies non-existent blocks.
    -Wuseless-cast  # Warn if something is being cast to its own type.
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

    if(USING_MSVC)
        set(warnings ${WARNINGS_MSVC})
    elseif(USING_CLANG)
        set(warnings ${WARNINGS_CLANG})
    elseif(USING_GCC)
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
    # Set the base warnings as defined in the constants.
    set_target_warnings(
        ${target}
            MSVC
                ${MSVC_BASE_WARNINGS}
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
