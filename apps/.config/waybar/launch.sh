#!/bin/bash
#  ____  _             _    __        __          _                 
# / ___|| |_ __ _ _ __| |_  \ \      / /_ _ _   _| |__   __ _ _ __  
# \___ \| __/ _` | '__| __|  \ \ /\ / / _` | | | | '_ \ / _` | '__| 
#  ___) | || (_| | |  | |_    \ V  V / (_| | |_| | |_) | (_| | |    
# |____/ \__\__,_|_|   \__|    \_/\_/ \__,_|\__, |_.__/ \__,_|_|    
#                                           |___/                   
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# Check if waybar-disabled file exists
if [ -f $HOME/.cache/waybar-disabled ] ;then 
    killall waybar
    pkill waybar
    exit 1 
fi

# ----------------------------------------------------- 
# Quit all running waybar instances
# ----------------------------------------------------- 
killall waybar
pkill waybar
sleep 0.5

# ----------------------------------------------------- 
# Default theme: /THEMEFOLDER;/VARIATION
# ----------------------------------------------------- 
style="/ml4w-blur;/ml4w-blur/white"

# ----------------------------------------------------- 
# Get current theme information from ~/.config/winghaa/settings/waybar-theme.sh
# ----------------------------------------------------- 
if [ -f ~/.config/winghaa/settings/waybar-theme.sh ]; then
    style=$(cat ~/.config/winghaa/settings/waybar-theme.sh)
else
    mkdir -p ~/.config/winghaa/settings
    touch ~/.config/winghaa/settings/waybar-theme.sh
    echo "$style" > ~/.config/winghaa/settings/waybar-theme.sh
fi

IFS=';' read -ra themes <<< "$style"
echo ":: Theme: ${themes[0]}"

if [ ! -f ~/.config/waybar/themes${themes[1]}/style.css ]; then
    style="/ml4w;/ml4w/light"
fi

# ----------------------------------------------------- 
# Loading the configuration
# ----------------------------------------------------- 
config_file="config"
style_file="style.css"

waybar -c ~/.config/waybar/themes${themes[0]}/$config_file -s ~/.config/waybar/themes${themes[1]}/$style_file &
