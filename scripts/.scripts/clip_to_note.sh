#!/bin/bash

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

SCRAP_FILE="$HOME/Documents/Notes/quick/scraps.md"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
CLIP_CONTENT=$(wl-paste 2>/dev/null || true)

if [ -z "$CLIP_CONTENT" ]; then
    log_warn "Clipboard is empty"
    dunstify -a notes -u critical \
        -h string:x-dunst-stack-tag:notes \
        -i dialog-error "Clipboard note failed" "Clipboard is empty."
    exit 1
fi

echo -e "## $TIMESTAMP\n$CLIP_CONTENT\n\n---" >>"$SCRAP_FILE"
log_ok "Clipboard saved to $SCRAP_FILE"

dunstify -a notes -u low \
    -h string:x-dunst-stack-tag:notes \
    -i edit-copy "Clipboard note saved" "Saved to scraps.md"
