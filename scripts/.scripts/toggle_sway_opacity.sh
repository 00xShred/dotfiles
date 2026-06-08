#!/bin/sh

state_file="${XDG_RUNTIME_DIR:-/tmp}/sway-opacity-state"

if [ "$(cat "$state_file" 2>/dev/null)" = "opaque" ]; then
    swaymsg '[all] opacity 0.95' >/dev/null
    printf '%s\n' translucent >"$state_file"
else
    swaymsg '[all] opacity 1.0' >/dev/null
    printf '%s\n' opaque >"$state_file"
fi
