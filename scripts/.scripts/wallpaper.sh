#!/bin/bash
set -x # Enable command tracing

hyprctl dispatch setfloating address:$(hyprctl activewindow -j | jq -r .address)
hyprctl dispatch centerwindow

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

# 3. APPLY SETTINGS
echo "Applying: $WALLPAPER"
swww img "$WALLPAPER" --transition-fps 60 --transition-step 90 --transition-type wipe --transition-angle 100

# Generate colors
wal -i "$WALLPAPER" || true

# 4. RELOAD EVERYTHING
hyprctl reload

# Restart background services using nohup
killall kanshi &>/dev/null
sleep 0.2
nohup kanshi >/dev/null 2>&1 &

killall waybar &>/dev/null
sleep 0.5
nohup waybar >/dev/null 2>&1 &

killall dunst &>/dev/null
sleep 0.2
nohup dunst >/dev/null 2>&1 &

# Update Apps
nvr --remote-send ":colorscheme neopywal<CR>" &>/dev/null & # Run nvr in background
pywalfox update &>/dev/null

echo "Done!"
exit 0
