include_guard()

set(CONAN_CMAKE_PATH "${CMAKE_BINARY_DIR}/conan.cmake")
set(CONAN_CMAKE_URL "https://github.com/conan-io/cmake-conan/raw/v0.15/conan.cmake")

function(ensure_conan_cmake)
    # Ensure conan.cmake is downloaded.
    if(NOT EXISTS "${CONAN_CMAKE_PATH}")
        message(STATUS "Downloading conan.cmake from ${CONAN_CMAKE_URL}")
        file(DOWNLOAD "${CONAN_CMAKE_URL}" "${CONAN_CMAKE_PATH}")
    endif()
endfunction()

macro(run_conan)
    # Run conan. This needs to be a macro because `conan_cmake_run` includes
    # files.
    #
    # Keyword args:
    #     PACKAGES: List of packages to download with Conan.
    #     EXTRA_OPTIONS: Extra options for conan.

    # Parse keyword arguments
    cmake_parse_arguments(
        CONAN
        ""
        ""
        "PACKAGES;EXTRA_OPTIONS"
        ${ARGN}
    )

    message("${PACKAGES}")

    conan_cmake_run(
        REQUIRES
            ${CONAN_PACKAGES}
        OPTIONS
            ${CONAN_EXTRA_OPTIONS}
            BASIC_SETUP
            CMAKE_TARGETS
        BUILD
            missing
    )
endmacro()

macro(conan)
    # Wrapper to run conan ensuring that `conan.cmake` is present.
    # Arguments are forwarded to `run_conan`.

    ensure_conan_cmake()
    include("${CONAN_CMAKE_PATH}")
    run_conan(${ARGN})
endmacro()
