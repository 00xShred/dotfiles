#!/bin/bash

# Directory setup
NOTE_DIR="/home/gabriel/Documents/Notes/quick"
mkdir -p "$NOTE_DIR"

# Find the highest existing note number
# This looks for note_N.md, extracts the number, sorts them, and grabs the last one
LAST_NUM=$(ls "$NOTE_DIR"/note_*.md 2>/dev/null | grep -oP 'note_\K\d+' | sort -n | tail -1)

# If no notes exist, start at 1; otherwise, increment by 1
if [ -z "$LAST_NUM" ]; then
    NEXT_NUM=1
else
    NEXT_NUM=$((LAST_NUM + 1))
fi

FILE_PATH="$NOTE_DIR/note_$NEXT_NUM.md"

# Launch terminal with a specific class so Hyprland can catch it
kitty --class floating_note nvim "$FILE_PATH"
