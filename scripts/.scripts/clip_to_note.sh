#!/bin/bash

SCRAP_FILE="/home/gabriel/Documents/Notes/quick/scraps.md"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
CLIP_CONTENT=$(wl-paste)

if [ -z "$CLIP_CONTENT" ]; then
    # Send an urgency 'critical' notification via Dunst
    notify-send -u critical "Scrapbook Error" "Clipboard is empty!"
    exit 1
fi

echo -e "## $TIMESTAMP\n$CLIP_CONTENT\n\n---" >>"$SCRAP_FILE"

# Standard Dunst notification
notify-send -i edit-copy "Scrapbook" "Saved to scraps.md"
