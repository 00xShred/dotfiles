#!/bin/bash
NOTE_DIR="$HOME/Documents/Notes/quick"

# 1. Use fzf to find a file
# We CD into the directory so the preview and selection paths are cleaner
cd "$NOTE_DIR" || exit
SELECTION=$(ls | fzf --preview "cat {}")

# 2. Open nvim in the CURRENT terminal window
if [ -n "$SELECTION" ]; then
    dunstify -a notes -u low \
        -h string:x-dunst-stack-tag:notes \
        -i accessories-text-editor "Opening note" "$SELECTION" 2>/dev/null || true
    nvim "$SELECTION"
fi
