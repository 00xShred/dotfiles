#!/bin/sh
# Usage: screenshot.sh [copy|save]
# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

area=$(slurp 2>/dev/null) || { log_warn "Selection cancelled"; exit 0; }

case "${1:-copy}" in
    copy)
        if grim -g "$area" - | wl-copy; then
            log_ok "Screenshot copied to clipboard"
            dunstify -a screenshot -u low \
                -h string:x-dunst-stack-tag:screenshot \
                -i camera-photo "Screenshot copied"
        else
            log_err "Screenshot capture failed"
            dunstify -a screenshot -u critical \
                -h string:x-dunst-stack-tag:screenshot \
                -i dialog-error "Screenshot failed" "Could not copy the selected area."
            exit 1
        fi
        ;;
    save)
        if grim -g "$area" - | swappy -f -; then
            log_ok "Screenshot opened in Swappy"
            dunstify -a screenshot -u low \
                -h string:x-dunst-stack-tag:screenshot \
                -i camera-photo "Screenshot opened" "Editing in Swappy."
        else
            log_err "Screenshot editor launch failed"
            dunstify -a screenshot -u critical \
                -h string:x-dunst-stack-tag:screenshot \
                -i dialog-error "Screenshot failed" "Could not open the selected area."
            exit 1
        fi
        ;;
    *)
        log_err "Usage: $0 [copy|save]"
        exit 2
        ;;
esac
