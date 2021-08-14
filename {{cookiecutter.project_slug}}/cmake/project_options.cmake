include_guard()

# A target that has the basic compiler options we wish to set for every other
# target.
# This doesn't produce any object, but transitively enables important options
# for the projects when "linked" against, without setting them globally.
add_library(
    project_options
        INTERFACE
)

# Enable the latest complete C++ standard.
target_compile_features(
    project_options
        INTERFACE
            cxx_std_20
)

# Enable the base warnings.
include(cmake/warnings.cmake)
set_target_base_warnings(project_options)

include(cmake/sanitizers.cmake)
enable_sanitizers(project_options)
