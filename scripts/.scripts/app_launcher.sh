#!/bin/sh

if [ -r "$HOME/.cache/wal/colors.sh" ]; then
	. "$HOME/.cache/wal/colors.sh"
fi

background=${background:-#080a13}
foreground=${foreground:-#c1c1c4}
selected=${color8:-#575a6b}
accent=${color4:-#3a5aa7}

if command -v wmenu >/dev/null 2>&1; then
	choice=$(
		{
			printf '%s\n' qutebrowser zen-browser kitty dolphin spotify Spotify spotify-launcher
			printf '%s' "$PATH" | tr ':' '\n' | while IFS= read -r dir; do
				[ -d "$dir" ] && find "$dir" -maxdepth 1 -type f -executable -printf '%f\n' 2>/dev/null
			done
		} | sort -u | wmenu \
		-i \
		-f "JetBrains Mono Nerd Font 11" \
		-N "$background" -n "$foreground" \
		-M "$selected" -m "$foreground" \
		-S "$accent" -s "$foreground"
	)
	[ -z "$choice" ] && exit 0

	case "$choice" in
		qutebrowser)
			exec sh -c 'qutebrowser "$@" >/tmp/qutebrowser-wmenu.log 2>&1' sh
			;;
		spotify|Spotify|spotify-launcher)
			pkill -x spotify 2>/dev/null; sleep 0.3
			exec spotify-launcher --skip-update
			;;
		*)
			exec sh -c 'exec "$@"' sh "$choice"
			;;
	esac
fi

exec fuzzel \
	--font "JetBrains Mono Nerd Font:size=11:weight=bold" \
	--prompt "" \
	--placeholder "Search" \
	--anchor top \
	--y-margin 6 \
	--width 34 \
	--lines 8 \
	--horizontal-pad 12 \
	--vertical-pad 4 \
	--inner-pad 4 \
	--border-width 0 \
	--border-radius 0 \
	--background-color "${background#\#}ff" \
	--text-color "${foreground#\#}ff" \
	--input-color "${foreground#\#}ff" \
	--placeholder-color "${selected#\#}ff" \
	--match-color "${accent#\#}ff" \
	--selection-color "${selected#\#}ff" \
	--selection-text-color "${foreground#\#}ff" \
	--selection-match-color "${foreground#\#}ff" \
	--filter-desktop \
	--terminal "kitty -e"
