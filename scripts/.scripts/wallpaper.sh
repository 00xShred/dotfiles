#!/bin/bash

# 1. VARIABLES
DIR="$HOME/Pictures/Wallpapers"

# 2. SELECT WALLPAPER (Preview via Kitty icat or Sixel)
cd "$DIR" || exit

if [ -n "$KITTY_PID" ] || [ "$TERM" = "xterm-kitty" ]; then
    PREVIEW_CMD='kitten icat --clear --transfer-mode=memory --stdin=no --place=${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0 {}'
elif command -v chafa >/dev/null 2>&1; then
    PREVIEW_CMD='chafa -f sixel -s ${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES} --scale max --align mid,mid --margin-bottom 0 {}'
else
    PREVIEW_CMD='magick {} -resize "$(( ${FZF_PREVIEW_COLUMNS:-50} * 11 ))x$(( ${FZF_PREVIEW_LINES:-25} * 22 ))" sixel:-'
fi

FZF_OUT=$(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) |
    sort |
    fzf --preview "$PREVIEW_CMD" \
        --preview-window=right:65% \
        --prompt="Choose Wallpaper [Enter: Auto, Ctrl+Z: Colorz, Ctrl+T: ColorThief] > " \
        --expect="ctrl-z,ctrl-t" \
        --border=rounded \
        --margin=1%)

KEY=$(printf "%s\n" "$FZF_OUT" | sed -n '1p')
SELECTED=$(printf "%s\n" "$FZF_OUT" | sed -n '2p')

# Exit if cancelled
if [ -z "$SELECTED" ]; then
    exit 0
fi

# Construct full path (remove ./ prefix if present)
WALLPAPER="$DIR/${SELECTED#./}"

# Determine backend (key override or smart pick)
case "$KEY" in
    ctrl-z)
        BACKEND="colorz"
        ;;
    ctrl-t)
        BACKEND="colorthief"
        ;;
    *)
        case "$(basename "$WALLPAPER" | tr '[:upper:]' '[:lower:]')" in
            *berserk*|*guts*)
                BACKEND="colorz"
                ;;
            *)
                BACKEND="wal"
                ;;
        esac
        ;;
esac

# 3. APPLY WALLPAPER
echo "Applying: $WALLPAPER ($BACKEND)"
dunstify -a wallpaper -u low \
    -h string:x-dunst-stack-tag:wallpaper \
    -i preferences-desktop-wallpaper "Applying wallpaper" "$(basename "$WALLPAPER") [$BACKEND]" 2>/dev/null || true

# Generate colors with fallback if colorz fails
if ! wal -i "$WALLPAPER" --backend "$BACKEND"; then
    echo "Backend $BACKEND failed, falling back to colorthief..."
    wal -i "$WALLPAPER" --backend colorthief || true
fi

# Ensure dark/monochrome palettes have distinct accents
if [ -x "$HOME/.scripts/wal-palette-guard.py" ]; then
    "$HOME/.scripts/wal-palette-guard.py" || true
fi

if [ -x "$HOME/.scripts/rebuild-dwl-theme.sh" ]; then
    "$HOME/.scripts/rebuild-dwl-theme.sh" || true
fi

pkill -USR1 -x dwl 2>/dev/null || true

# 4. RELOAD EVERYTHING
if command -v swaymsg >/dev/null 2>&1 && [ -n "$SWAYSOCK" ]; then
    "$HOME/.scripts/reload_sway.sh" >/dev/null 2>&1 || true
fi

if [ -x "$HOME/.local/bin/somebar" ]; then
    "$HOME/.local/bin/somebar" -c "status reloaded" &>/dev/null || true
fi

# Update Apps
nvr --remote-send ":colorscheme neopywal<CR>" &>/dev/null & # Run nvr in background
pywalfox update &>/dev/null

qutebrowser ':config-source' &>/dev/null &

dunstify -a wallpaper -u normal \
    -h string:x-dunst-stack-tag:wallpaper \
    -i preferences-desktop-wallpaper "Wallpaper applied" "$(basename "$WALLPAPER")" 2>/dev/null || true

echo "Done!"
exit 0
