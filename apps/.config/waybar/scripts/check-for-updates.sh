#!/bin/bash
#  _   _           _       _
# | | | |_ __   __| | __ _| |_ ___  ___
# | | | | '_ \ / _` |/ _` | __/ _ \/ __|
# | |_| | |_) | (_| | (_| | ||  __/\__ \
#  \___/| .__/ \__,_|\__,_|\__\___||___/
#       |_|
#

# -----------------------------------------------------
# Define threshholds for color indicators
# -----------------------------------------------------

threshhold_green=0
threshhold_yellow=25
threshhold_red=100
aur_helper="paru"

# -----------------------------------------------------
# Calculate available updates
# -----------------------------------------------------

if [ -f /etc/os-release ]; then
    . /etc/os-release

    case "$ID" in
        arch)
            if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
                updates_arch=0
            fi

            if ! updates_aur=$($aur_helper -Qu --aur --quiet | wc -l); then
                updates_aur=0
            fi

            updates=$(("$updates_arch" + "$updates_aur"))
            ;;

        ubuntu)
            if ! updates_ubuntu=$(apt list --upgradable 2> /dev/null | grep -v 'Listing...' | wc -l); then
                updates_ubuntu=0
            fi

            updates=$updates_ubuntu
            ;;

        *)
            updates=0
            ;;
    esac
else
    updates=0
fi

# -----------------------------------------------------
# Output in JSON format for Waybar Module custom-updates
# -----------------------------------------------------

css_class="green"

if [ "$updates" -gt $threshhold_yellow ]; then
    css_class="yellow"
fi

if [ "$updates" -gt $threshhold_red ]; then
    css_class="red"
fi

if [ "$updates" -gt $threshhold_green ]; then
    printf '{"text": "%s", "alt": "%s", "class": "%s"}' "$updates" "$updates" "$updates" "$css_class"
else
    printf '{"text": "0", "alt": "0", "class": "green"}'
fi
