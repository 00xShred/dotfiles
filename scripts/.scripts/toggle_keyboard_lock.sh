#!/bin/sh

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

state="${XDG_RUNTIME_DIR:-/tmp}/sway-keyboard-lock"
timeout="${KEYBOARD_LOCK_TIMEOUT:-30}"

notify() {
    dunstify -a sway -u low -h string:x-dunst-stack-tag:keyboard-lock "$1" "$2" 2>/dev/null || true
}

unlock() {
    swaymsg input type:keyboard events enabled >/dev/null
    rm -f "$state"
    log_ok "Keyboard unlocked"
    notify "Keyboard unlocked" ""
}

if [ -e "$state" ]; then
    unlock
    exit 0
fi

: >"$state"
swaymsg input type:keyboard events disabled >/dev/null
log_warn "Keyboard locked (auto-unlock in ${timeout}s)"
notify "Keyboard locked" "Auto-unlocks in ${timeout}s"

(
    sleep "$timeout"
    [ -e "$state" ] || exit 0
    swaymsg input type:keyboard events enabled >/dev/null 2>&1 || exit 0
    rm -f "$state"
    notify "Keyboard unlocked" "Timeout reached"
) &
