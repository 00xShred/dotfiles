#!/bin/sh

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

case "$1" in
text|image)
    type="$1"
    ;;
*)
    log_err "Usage: $0 [text|image]"
    exit 2
    ;;
esac

pkill -f "wl-paste --type $type --watch [c]liphist store" 2>/dev/null || true
log_info "Watching clipboard: $type"
exec wl-paste --type "$type" --watch cliphist store
