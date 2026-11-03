#!/bin/sh

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

colors="$HOME/.cache/wal/colors-sway"
wallpaper=$(sed -n 's/^set \$wallpaper //p' "$colors" | head -n 1)

if [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ]; then
    log_err "Wallpaper missing: ${wallpaper:-No wallpaper configured}"
    dunstify -a wallpaper -u critical \
        -h string:x-dunst-stack-tag:wallpaper \
        -i dialog-error "Wallpaper missing" "${wallpaper:-No wallpaper configured}" 2>/dev/null || true
    exit 1
fi

killall swaybg 2>/dev/null || true
log_info "Launching swaybg: $wallpaper"
exec swaybg -i "$wallpaper" -m fill
