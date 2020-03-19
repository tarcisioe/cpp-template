include_guard()

# Define variables for each supported compiler, so that checking is easier
# later.

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(USING_CLANG TRUE)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(USING_GCC TRUE)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    set(USING_MSVC TRUE)
endif()
