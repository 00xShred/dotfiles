#!/bin/bash

# Get list of clipboard entries (ID + preview)
entries=$(cliphist list)

# Exit if empty
[ -z "$entries" ] && {
    dunstify -a clipboard -u low \
        -h string:x-dunst-stack-tag:clipboard \
        -i edit-paste "Clipboard empty"
    exit
}

# Show menu and capture selection
chosen=$(echo "$entries" | wofi --dmenu --prompt "Paste from history..." --insensitive)

# Exit if cancelled
[ -z "$chosen" ] && exit

# Extract ID (first field before tab)
id=$(printf '%s' "$chosen" | cut -f1)

# Decode full content and copy to clipboard
cliphist decode "$id" | wl-copy

dunstify -a clipboard -u low \
    -h string:x-dunst-stack-tag:clipboard \
    -i edit-paste "Copied from history"
