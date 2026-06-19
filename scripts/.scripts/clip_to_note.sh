#!/bin/bash

SCRAP_FILE="$HOME/Documents/Notes/quick/scraps.md"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
CLIP_CONTENT=$(wl-paste)

if [ -z "$CLIP_CONTENT" ]; then
    dunstify -a notes -u critical \
        -h string:x-dunst-stack-tag:notes \
        -i dialog-error "Clipboard note failed" "Clipboard is empty."
    exit 1
fi

echo -e "## $TIMESTAMP\n$CLIP_CONTENT\n\n---" >>"$SCRAP_FILE"

dunstify -a notes -u low \
    -h string:x-dunst-stack-tag:notes \
    -i edit-copy "Clipboard note saved" "Saved to scraps.md"
