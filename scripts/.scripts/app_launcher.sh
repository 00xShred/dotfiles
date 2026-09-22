#!/bin/sh

if [ -r "$HOME/.cache/wal/colors.sh" ]; then
    . "$HOME/.cache/wal/colors.sh"
fi

background=${background:-#080a13}
foreground=${foreground:-#c1c1c4}
selected=${color8:-#575a6b}
accent=${color4:-#3a5aa7}
launcher_font=${APP_LAUNCHER_FONT:-"JetBrains Mono Nerd Font:size=8:weight=bold"}
launcher_width=${APP_LAUNCHER_WIDTH:-56}
launcher_lines=${APP_LAUNCHER_LINES:-8}

if command -v fuzzel >/dev/null 2>&1; then
    exec fuzzel \
        --font "$launcher_font" \
        --use-bold \
        --prompt "" \
        --placeholder "Search" \
        --anchor center \
        --y-margin 0 \
        --width "$launcher_width" \
        --lines "$launcher_lines" \
        --horizontal-pad 14 \
        --vertical-pad 8 \
        --inner-pad 4 \
        --border-width 0 \
        --border-radius 0 \
        --selection-radius 0 \
        --layer overlay \
        --match-mode fzf \
        --fields name,generic,comment,categories,keywords \
        --show-actions \
        --filter-desktop \
        --list-executables-in-path \
        --delayed-filter-ms 60 \
        --terminal "${TERMINAL:-foot} -e" \
        --background-color "${background#\#}ff" \
        --text-color "${foreground#\#}ff" \
        --input-color "${foreground#\#}ff" \
        --placeholder-color "${selected#\#}ff" \
        --counter-color "${selected#\#}ff" \
        --match-color "${accent#\#}ff" \
        --selection-color "${selected#\#}ff" \
        --selection-text-color "${foreground#\#}ff" \
        --selection-match-color "${foreground#\#}ff"
fi

if command -v wmenu >/dev/null 2>&1; then
    choice=$(
        {
            printf '%s\n' qutebrowser zen-browser foot kitty dolphin spotify Spotify spotify-launcher
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
    spotify | Spotify | spotify-launcher)
        pkill -x spotify 2>/dev/null
        sleep 0.3
        exec spotify-launcher --skip-update
        ;;
    *)
        exec sh -c 'exec "$@"' sh "$choice"
        ;;
    esac
fi

printf '%s\n' "app_launcher.sh: install fuzzel or wmenu" >&2
exit 1
