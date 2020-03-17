# Enable compile database for tools that rely on it.
# This creates a build/compile_commands.json that informs tools such as
# autocomplete or linter of compiler settings for each file.
set(CMAKE_EXPORTS_COMPILE_COMMANDS ON)

# Target for setting options we want enabled by default. This doesn't produce
# any object, but transitively enables important features for the projects,
# without setting them globally.
add_library(
    project_options
        INTERFACE
)

# Enable the latest complete C++ standard.
target_compile_features(
    project_options
        INTERFACE
            cxx_std_17
)

# Enable the base warnings.
include(cmake/warnings.cmake)
set_target_base_warnings(project_options)
