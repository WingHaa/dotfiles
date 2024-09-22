#!/bin/bash

# Check if GNU Stow is installed
if ! command -v stow &> /dev/null; then
    echo "GNU Stow is not installed. Please install it first."
    exit 1
fi

stow -vR "apps"
