#!/bin/bash

# Check if GNU Stow is installed
if ! command -v stow &> /dev/null; then
    echo "GNU Stow is not installed. Please install it first."
    exit 1
fi

# Define the list of directories to ignore
ignores=("setup.sh" "scripts" ".git" ".gitmodules" ".stow-global-ignore")

# Build the find command with the ignore conditions
ignore_patterns=""
for item in "${ignores[@]}"; do
    ignore_patterns+=" -not -name '$item'"
done

# Get a list of all directories in the current directory
directories=$(eval "find . -maxdepth 1 ! -name '.' $ignore_patterns")

# Loop through each directory and stow it
for dir in $directories; do
    echo "Stowing $dir..."
    stow -vR "$(basename "$dir")"
done

echo "All directories have been stowed."

