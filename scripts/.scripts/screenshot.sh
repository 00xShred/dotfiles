#!/bin/sh
# Usage: screenshot.sh [copy|save]
area=$(slurp 2>/dev/null) || exit 0

case "${1:-copy}" in
    copy)
        grim -g "$area" - | wl-copy
        ;;
    save)
        grim -g "$area" - | swappy -f -
        ;;
    *)
        printf 'Usage: %s [copy|save]\n' "$0" >&2
        exit 2
        ;;
esac
