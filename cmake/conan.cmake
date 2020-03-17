set(CONAN_CMAKE_PATH "${CMAKE_BINARY_DIR}/conan.cmake")
set(CONAN_CMAKE_URL "https://github.com/conan-io/cmake-conan/raw/v0.15/conan.cmake")

function(ensure_conan_cmake)
    # Ensure conan.cmake is downloaded.
    if(NOT EXISTS "${CONAN_CMAKE_PATH}")
        message(STATUS "Downloading conan.camke from ${CONAN_CMAKE_URL}")
        file(DOWNLOAD "${CONAN_CMAKE_URL}" "${CONAN_CMAKE_PATH}")
    endif()

    include("${CONAN_CMAKE_PATH}")
endfunction()

function(conan)
    # Parse keyword arguments
    cmake_parse_arguments(
        CONAN
        ""
        ""
        "PACKAGES;EXTRA_OPTIONS"
        ${ARGN}
    )

    ensure_conan_cmake()

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
endfunction()
