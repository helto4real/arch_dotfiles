
# Add user-specific executables to PATH
path+=~/.local/bin         # User-installed binaries and scripts

# Add language-specific package tools
path+=~/.dotnet/tools      # .NET Core global tools

# Export the modified PATH to make changes available to subprocesses
export PATH
