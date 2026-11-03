#!/bin/bash

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

NOTE_DIR="$HOME/Documents/Notes/quick"
mkdir -p "$NOTE_DIR"

# 1. Use fzf to find a file
cd "$NOTE_DIR" || exit
PREVIEW_BIN=$(command -v bat >/dev/null 2>&1 && echo "bat --style=plain --color=always" || echo "cat")
SELECTION=$(ls 2>/dev/null | fzf --preview "$PREVIEW_BIN {}")

# 2. Open nvim in the CURRENT terminal window
if [ -n "$SELECTION" ]; then
    log_info "Opening note: $SELECTION"
    dunstify -a notes -u low \
        -h string:x-dunst-stack-tag:notes \
        -i accessories-text-editor "Opening note" "$SELECTION" 2>/dev/null || true
    nvim "$SELECTION"
else
    log_warn "No note selected"
fi
