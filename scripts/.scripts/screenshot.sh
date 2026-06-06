#!/bin/sh
# Usage: screenshot.sh [copy|save]
AREA=$(slurp 2>/dev/null) || exit 0
case "${1:-copy}" in
    copy) grim -g "$AREA" - | wl-copy ;;
    save) grim -g "$AREA" - | swappy -f - ;;
esac
