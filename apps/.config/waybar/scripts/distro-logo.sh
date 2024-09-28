#!/bin/bash

# Define the path to your icons
ICON_PATH="$HOME/.config/waybar/os-icons"

# Function to get the logo key from /etc/os-release
get_logo_name() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$LOGO"  # Return the LOGO key from os-release
    else
        echo "unknown"  # Fallback for unknown OS
    fi
}

# Function to find the logo path using plocate or mlocate, or fallback to find
get_logo_path() {
    local logo_pattern="$1"
    
    if command -v plocate &> /dev/null; then
        plocate "${logo_pattern}.svg" | head -n 1
    elif command -v mlocate &> /dev/null; then
        mlocate "${logo_pattern}.svg" | head -n 1
    else
        find "$ICON_PATH" -name "${logo_pattern}.svg" 2>/dev/null | head -n 1
    fi
}

LOGO=$(get_logo_name)
LOGO_PATH=$(get_logo_path "$LOGO")

cat <<EOL > ~/.config/waybar/dynamic-css/appmenu_icon.css
#custom-appmenu_icon,
#custom-appmenu_icon_label {
    margin-right: 16px;
    background-image: url("$LOGO_PATH");
    background-repeat: no-repeat;
    background-size: contain;
    padding-right: 18px;
}
EOL

echo 'whatever'
