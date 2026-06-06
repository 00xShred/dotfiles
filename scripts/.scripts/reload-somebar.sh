#!/bin/sh

somebar_cmd="$HOME/.local/bin/somebar"
[ -x "$somebar_cmd" ] || somebar_cmd="$(command -v somebar)"

if [ -n "$somebar_cmd" ]; then
	"$somebar_cmd" -c "show all" >/tmp/somebar-reload.log 2>&1 || true
	"$somebar_cmd" -c "status reloaded" >>/tmp/somebar-reload.log 2>&1 || true
fi

pkill -f "$HOME/.scripts/somebar-status.sh" >/dev/null 2>&1 || true
setsid -f "$HOME/.scripts/somebar-status.sh" >/tmp/somebar-status.log 2>&1
