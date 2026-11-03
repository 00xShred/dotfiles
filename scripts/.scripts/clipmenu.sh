#!/bin/bash

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

# Get list of clipboard entries (ID + preview)
entries=$(cliphist list)

# Exit if empty
[ -z "$entries" ] && {
    log_warn "Clipboard history is empty"
    dunstify -a clipboard -u low \
        -h string:x-dunst-stack-tag:clipboard \
        -i edit-paste "Clipboard empty"
    exit 0
}

# Show menu and capture selection
chosen=$(echo "$entries" | fuzzel --dmenu --prompt "󰅍  " --width 60)

# Exit if cancelled
[ -z "$chosen" ] && { log_info "Clipboard selection cancelled"; exit 0; }

# Extract ID (first field before tab)
id=$(printf '%s' "$chosen" | cut -f1)

# Decode full content and copy to clipboard
cliphist decode "$id" | wl-copy
log_ok "Restored clipboard item #$id"

dunstify -a clipboard -u low \
    -h string:x-dunst-stack-tag:clipboard \
    -i edit-paste "Copied from history"
