#!/bin/bash

if command -v hyprctl >/dev/null 2>&1 && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    hyprctl dispatch setfloating address:$(hyprctl activewindow -j | jq -r .address)
    hyprctl dispatch centerwindow
fi

# 1. VARIABLES
DIR="$HOME/Pictures/Wallpapers"

# 2. SELECT WALLPAPER (Using fzf with Kitty image preview)
cd "$DIR" || exit

SELECTED=$(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) |
    sort |
    fzf --preview 'kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}' \
        --preview-window=right:60% \
        --prompt="Choose Wallpaper > " \
        --border=rounded \
        --margin=5%)

# Exit if cancelled
if [ -z "$SELECTED" ]; then
    exit 0
fi

# Construct full path (remove ./ prefix if present)
WALLPAPER="$DIR/${SELECTED#./}"

# 3. APPLY WALLPAPER
echo "Applying: $WALLPAPER"
killall swaybg &>/dev/null
nohup swaybg -i "$WALLPAPER" -m fill >/dev/null 2>&1 &

# Generate colors
wal -i "$WALLPAPER" || true

if [ -x "$HOME/.scripts/rebuild-dwl-theme.sh" ]; then
    "$HOME/.scripts/rebuild-dwl-theme.sh" || true
fi

pkill -USR1 -x dwl 2>/dev/null || true

# 4. RELOAD EVERYTHING
if command -v hyprctl >/dev/null 2>&1 && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    hyprctl reload
fi

if command -v swaymsg >/dev/null 2>&1 && [ -n "$SWAYSOCK" ]; then
    swaymsg reload >/dev/null 2>&1 || true
fi

# Restart background services using nohup
killall kanshi &>/dev/null
sleep 0.2
nohup kanshi >/dev/null 2>&1 &

if command -v waybar >/dev/null 2>&1 && { [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] || [ -n "$SWAYSOCK" ]; }; then
    killall waybar &>/dev/null
    sleep 0.5
    nohup waybar >/dev/null 2>&1 &
fi

if [ -x "$HOME/.local/bin/somebar" ]; then
    "$HOME/.local/bin/somebar" -c "status reloaded" &>/dev/null || true
fi

killall dunst &>/dev/null
sleep 0.2
nohup dunst >/dev/null 2>&1 &

# Update Apps
nvr --remote-send ":colorscheme neopywal<CR>" &>/dev/null & # Run nvr in background
pywalfox update &>/dev/null

qutebrowser ':config-source' &>/dev/null &

echo "Done!"
exit 0
