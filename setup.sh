#!/bin/bash

# Check if GNU Stow is installed
if ! command -v stow &> /dev/null; then
    echo "GNU Stow is not installed. Please install it first."
    exit 1
fi

# Get a list of all directories in the current directory
directories=$(find . -maxdepth 1 -type d ! -name '.')

# Loop through each directory and stow it
for dir in $directories; do
    echo "Stowing $dir..."
    stow -vSR "$(basename "$dir")"
done

echo "All directories have been stowed."

