#!/bin/bash
NOTE_DIR="/home/gabriel/Documents/Notes/quick"

# Use fzf to find a file based on content or name
SELECTION=$(ls "$NOTE_DIR" | fzf --preview "cat $NOTE_DIR/{}")

if [ -n "$SELECTION" ]; then
    kitty --class floating_note nvim "$NOTE_DIR/$SELECTION"
fi
