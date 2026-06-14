#!/bin/sh
# Usage: screenshot.sh [copy|save]
area=$(slurp 2>/dev/null) || exit 0

case "${1:-copy}" in
    copy)
        if grim -g "$area" - | wl-copy; then
            dunstify -a screenshot -u low \
                -h string:x-dunst-stack-tag:screenshot \
                -i camera-photo "Screenshot copied"
        else
            dunstify -a screenshot -u critical \
                -h string:x-dunst-stack-tag:screenshot \
                -i dialog-error "Screenshot failed" "Could not copy the selected area."
            exit 1
        fi
        ;;
    save)
        if grim -g "$area" - | swappy -f -; then
            dunstify -a screenshot -u low \
                -h string:x-dunst-stack-tag:screenshot \
                -i camera-photo "Screenshot opened" "Editing in Swappy."
        else
            dunstify -a screenshot -u critical \
                -h string:x-dunst-stack-tag:screenshot \
                -i dialog-error "Screenshot failed" "Could not open the selected area."
            exit 1
        fi
        ;;
    *)
        printf 'Usage: %s [copy|save]\n' "$0" >&2
        exit 2
        ;;
esac
