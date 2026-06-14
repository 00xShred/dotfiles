#!/bin/sh

# Clean up helpers that can outlive a config reload, then let Sway recreate
# the services declared with exec_always and the built-in bar block.
killall waybar 2>/dev/null || true
killall swaybar 2>/dev/null || true
pkill -f "/home/gabriel/.scripts/swaybar_status.sh" 2>/dev/null || true
pkill -f "$HOME/.scripts/swaybar_status.sh" 2>/dev/null || true
killall swaybg 2>/dev/null || true

swaymsg reload >/dev/null || exit 1
nohup "$HOME/.scripts/start_wallpaper.sh" >/dev/null 2>&1 &

dunstify -a sway -u low \
    -h string:x-dunst-stack-tag:sway \
    -i preferences-system-windows "Sway reloaded" 2>/dev/null || true
