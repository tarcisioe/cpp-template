# Enable compile database for tools that rely on it.
# This creates a build/compile_commands.json that informs tools such as
# autocomplete or linter of compiler settings for each file.
set(CMAKE_EXPORTS_COMPILE_COMMANDS ON)
