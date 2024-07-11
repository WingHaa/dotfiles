#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for changing blurs on the fly

STATE=$(hyprctl -j getoption decoration:blur:passes | jq ".int")

if [ "${STATE}" == "2" ]; then
    hyprctl keyword decoration:blur:size 2
    hyprctl keyword decoration:blur:passes 1
    notify-send -e -u low "Low blur"
else
    hyprctl keyword decoration:blur:size 5
    hyprctl keyword decoration:blur:passes 2
    notify-send -e -u low "Normal blur"
fi
