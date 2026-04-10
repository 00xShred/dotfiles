#!/bin/bash
NOTE_DIR="/home/gabriel/Documents/Notes/quick"

# 1. Use fzf to find a file
# We CD into the directory so the preview and selection paths are cleaner
cd "$NOTE_DIR" || exit
SELECTION=$(ls | fzf --preview "cat {}")

# 2. Open nvim in the CURRENT terminal window
if [ -n "$SELECTION" ]; then
    nvim "$SELECTION"
fi
