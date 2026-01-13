#!/bin/bash

hyprctl dispatch setfloating address:$(hyprctl activewindow -j | jq -r .address)
hyprctl dispatch centerwindow

# 1. VARIABLES
DIR="$HOME/Pictures/Wallpapers"

# 2. SELECT WALLPAPER (Using fzf with Kitty image preview)
# We change directory to DIR so fzf lists just filenames, but we keep the full path for the logic
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
#!/bin/bash

# ... (keep your existing fzf selection code at the top) ...

# 3. APPLY SETTINGS
echo "Applying: $WALLPAPER"
swww img "$WALLPAPER" --transition-fps 60 --transition-step 90 --transition-type wipe --transition-angle 100

# Generate colors
# Added '|| true' so the script continues even if pywalfox throws a minor error
wal -i "$WALLPAPER" || true

# 4. RELOAD EVERYTHING
hyprctl reload

# Restart background services
# We sleep to give them time to close properly before restarting

killall kanshi &>/dev/null
sleep 0.5
kanshi >/dev/null 2>&1 &
disown

killall waybar &>/dev/null
sleep 0.5 # <--- THIS IS CRITICAL
waybar >/dev/null 2>&1 &
disown

killall dunst &>/dev/null
sleep 0.5
dunst >/dev/null 2>&1 &
disown

# Update Apps
nvr --remote-send ":colorscheme neopywal<CR>" &>/dev/null
pywalfox update &>/dev/null

echo "Done!"
exit 0
