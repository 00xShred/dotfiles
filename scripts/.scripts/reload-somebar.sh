#!/bin/sh

log=/tmp/somebar-reload.log

{
	printf 'reload started: %s\n' "$(date)"

	if [ -x "$HOME/.scripts/rebuild-dwl-theme.sh" ]; then
		if ! "$HOME/.scripts/rebuild-dwl-theme.sh"; then
			printf 'theme rebuild failed; keeping current somebar running\n' >&2
			exit 1
		fi
	fi

	somebar_cmd="$HOME/.local/bin/somebar"
	[ -x "$somebar_cmd" ] || somebar_cmd="$(command -v somebar)"

	pkill -f "$HOME/.scripts/somebar-status.sh" >/dev/null 2>&1 || true
	pkill -x somebar >/dev/null 2>&1 || true

	if [ -n "$XDG_RUNTIME_DIR" ]; then
		rm -f "$XDG_RUNTIME_DIR"/somebar-* 2>/dev/null || true
	fi

	if [ -n "$somebar_cmd" ]; then
		setsid -f "$somebar_cmd" </dev/null >/tmp/somebar.log 2>&1
		sleep 0.2
	fi

	if [ -x "$HOME/.scripts/somebar-status.sh" ]; then
		setsid -f "$HOME/.scripts/somebar-status.sh" >/tmp/somebar-status.log 2>&1
	fi

	printf 'reload finished: %s\n' "$(date)"
} >"$log" 2>&1

exit 0
