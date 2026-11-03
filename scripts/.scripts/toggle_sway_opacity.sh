#!/bin/sh

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

config_file="${XDG_CONFIG_HOME:-$HOME/.config}/sway/opacity.conf"
current=$(awk '/^for_window \[all\] opacity/{print $NF; exit}' "$config_file")

if [ "$current" = "1.0" ]; then
    target=0.97
else
    target=1.0
fi

tmp="$config_file.tmp.$$"
printf 'for_window [all] opacity %s\n' "$target" >"$tmp" && mv "$tmp" "$config_file"
swaymsg reload >/dev/null
swaymsg "[all] opacity $target" >/dev/null
log_info "Sway opacity toggled: $current -> $target"
