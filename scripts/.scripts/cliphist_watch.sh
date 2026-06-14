#!/bin/sh

case "$1" in
text|image)
    type="$1"
    ;;
*)
    printf 'Usage: %s [text|image]\n' "$0" >&2
    exit 2
    ;;
esac

pkill -f "wl-paste --type $type --watch [c]liphist store" 2>/dev/null || true
exec wl-paste --type "$type" --watch cliphist store
