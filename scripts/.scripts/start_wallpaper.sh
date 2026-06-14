#!/bin/sh

colors="$HOME/.cache/wal/colors-sway"
wallpaper=$(sed -n 's/^set \$wallpaper //p' "$colors" | head -n 1)

if [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ]; then
    dunstify -a wallpaper -u critical \
        -h string:x-dunst-stack-tag:wallpaper \
        -i dialog-error "Wallpaper missing" "${wallpaper:-No wallpaper configured}" 2>/dev/null || true
    exit 1
fi

killall swaybg 2>/dev/null || true
exec swaybg -i "$wallpaper" -m fill
