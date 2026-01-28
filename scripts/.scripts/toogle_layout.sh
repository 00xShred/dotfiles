#!/bin/bash

# Get the current layout configuration
CURRENT_LAYOUT=$(hyprctl getoption general:layout | grep 'str' | awk '{print $2}' | sed 's/"//g')

if [ "$CURRENT_LAYOUT" = "master" ]; then
    hyprctl keyword general:layout dwindle
    notify-send "Layout: Dwindle"
else
    hyprctl keyword general:layout master
    notify-send "Layout: Master"
fi
