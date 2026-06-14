#!/bin/sh

COLOR_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/wal/colors-sway"

wal_color() {
    awk -v name="$1" '$1 == "set" && $2 == name { print $3; exit }' "$COLOR_FILE" 2>/dev/null
}

foreground=$(wal_color '$foreground')
muted=$(wal_color '$color8')
accent=$(wal_color '$color4')
good=$(wal_color '$color2')
warn=$(wal_color '$color5')
bad=$(wal_color '$color1')
info=$(wal_color '$color6')

foreground=${foreground:-#c1c1c4}
muted=${muted:-#575a6b}
accent=${accent:-#3A5AA7}
good=${good:-#C1A554}
warn=${warn:-#B661A5}
bad=${bad:-#A11B4D}
info=${info:-#2B9FDE}
show_center=true

case "${1:-}" in
--no-center)
    show_center=false
    ;;
esac

block() {
    name=$1
    instance=${2:-}
    full_text=$3
    color=${4:-$foreground}
    urgent=${5:-false}

    jq -cn \
        --arg name "$name" \
        --arg instance "$instance" \
        --arg full_text "$full_text" \
        --arg color "$color" \
        --argjson urgent "$urgent" \
        '{
            name: $name,
            instance: $instance,
            full_text: $full_text,
            color: $color,
            urgent: $urgent,
            separator: false,
            separator_block_width: 12
        }'
}

center_block() {
    full_text=$1
    color=${2:-$foreground}
    min_width=$(center_min_width)

    jq -cn \
        --arg full_text "$full_text" \
        --arg color "$color" \
        --argjson min_width "$min_width" \
        '{
            name: "center",
            instance: "",
            full_text: $full_text,
            color: $color,
            min_width: $min_width,
            align: "center",
            separator: false,
            separator_block_width: 0
        }'
}

append_block() {
    new_block=$1

    if [ -z "$blocks" ]; then
        blocks=$new_block
    else
        blocks="$blocks,$new_block"
    fi
}

center_min_width() {
    printf '1510'
}

truncate() {
    max=$1
    text=$2

    if [ "${#text}" -le "$max" ]; then
        printf '%s' "$text"
    else
        printf '%s...' "$(printf '%s' "$text" | cut -c "1-$((max - 3))")"
    fi
}

watch_clicks() {
    while IFS= read -r event; do
        printf '%s' "$event" | jq -e 'select(.name == "battery")' >/dev/null 2>&1 || continue
        "$HOME/.scripts/toggle_power.sh" >/dev/null 2>&1
    done
}

network_block() {
    wifi=$(nmcli -t -f ACTIVE,SSID,SIGNAL dev wifi 2>/dev/null | awk -F: '$1 == "yes" { print $2 "|" $3; exit }')
    if [ -n "$wifi" ]; then
        signal=$(printf '%s' "$wifi" | cut -d'|' -f2)
        block network "" "󰤨 ${signal}%" "$info"
        return
    fi

    ethernet=$(nmcli -t -f DEVICE,TYPE,STATE dev status 2>/dev/null | awk -F: '$2 == "ethernet" && $3 == "connected" { print $1; exit }')
    if [ -n "$ethernet" ]; then
        block network "" "󰈀 $ethernet" "$info"
        return
    fi

    block network "" "󰤭" "$bad" true
}

ram_block() {
    awk -v color="$warn" '
        /^MemTotal:/ { total = $2 }
        /^MemAvailable:/ { available = $2 }
        END {
            if (total > 0) {
                used = total - available
                pct = int((used / total) * 100 + 0.5)
                printf "%d\n", pct
            }
        }' /proc/meminfo | while read -r pct; do
        [ -n "$pct" ] || continue
        color=$accent
        urgent=false
        [ "$pct" -ge 75 ] && color=$warn
        if [ "$pct" -ge 90 ]; then
            color=$bad
            urgent=true
        fi
        block ram "" "󰍛 ${pct}%" "$color" "$urgent"
    done
}

battery_block() {
    profile=$(powerprofilesctl get 2>/dev/null)
    [ -n "$profile" ] || profile="unknown"

    for capacity in /sys/class/power_supply/BAT*/capacity; do
        [ -r "$capacity" ] || continue

        status_file="${capacity%/capacity}/status"
        status="Unknown"
        [ -r "$status_file" ] && status=$(cat "$status_file")
        pct=$(cat "$capacity")

        case "$status" in
        Charging)
            icon="󰂄"
            color=$foreground
            urgent=false
            ;;
        Full)
            icon="󰁹"
            color=$foreground
            urgent=false
            ;;
        *)
            if [ "$pct" -le 10 ]; then
                icon="󰁺"
                color=$bad
                urgent=true
            elif [ "$pct" -le 20 ]; then
                icon="󰁻"
                color=$warn
                urgent=false
            elif [ "$pct" -le 40 ]; then
                icon="󰁽"
                color=$foreground
                urgent=false
            elif [ "$pct" -le 60 ]; then
                icon="󰁿"
                color=$foreground
                urgent=false
            elif [ "$pct" -le 80 ]; then
                icon="󰂁"
                color=$foreground
                urgent=false
            else
                icon="󰁹"
                color=$foreground
                urgent=false
            fi
            ;;
        esac

        profile_icon="󰌪"
        [ "$profile" = "balanced" ] && profile_icon="󰗑"
        [ "$profile" = "performance" ] && profile_icon="󰓅"

        block battery "$profile" "$profile_icon ${pct}%" "$color" "$urgent"
        return
    done
}

temp_block() {
    temp=$(sensors 2>/dev/null | awk '
        /^CPU:/ || /^Tctl:/ || /^Package id 0:/ {
            for (i = 1; i <= NF; i++) {
                if ($i ~ /^\+[0-9.]+°C$/) {
                    gsub(/[+°C]/, "", $i)
                    printf "%d", $i
                    exit
                }
            }
        }')

    [ -n "$temp" ] || return

    color=$good
    urgent=false
    if [ "$temp" -ge 85 ]; then
        color=$bad
        urgent=true
    elif [ "$temp" -ge 70 ]; then
        color=$warn
    fi

    block temp "" " ${temp}°" "$color" "$urgent"
}

center_text() {
    date_text=$(date '+%a %d %b  %H:%M')
    selected_player=""
    selected_status=""
    players=$(playerctl -l 2>/dev/null)

    for wanted_status in Playing Paused; do
        for player in $players; do
            case "$player" in
            spotify*) ;;
            *) continue ;;
            esac
            status=$(playerctl -p "$player" status 2>/dev/null) || continue
            [ "$status" = "$wanted_status" ] || continue
            selected_player=$player
            selected_status=$status
            break
        done

        [ -n "$selected_player" ] && break

        for player in $players; do
            status=$(playerctl -p "$player" status 2>/dev/null) || continue
            [ "$status" = "$wanted_status" ] || continue
            selected_player=$player
            selected_status=$status
            break
        done
        [ -n "$selected_player" ] && break
    done

    [ -n "$selected_player" ] || {
        printf '%s' "$date_text"
        return
    }

    artist=$(playerctl -p "$selected_player" metadata artist 2>/dev/null)
    song=$(playerctl -p "$selected_player" metadata title 2>/dev/null)
    if [ -n "$artist" ] && [ -n "$song" ]; then
        title="$artist - $song"
    else
        title="${song:-$artist}"
    fi
    [ -n "$title" ] || {
        printf '%s' "$date_text"
        return
    }

    if [ "$selected_status" = "Paused" ]; then
        icon="󰏤"
    else
        icon="󰝚"
    fi

    printf '%s   %s %s' "$date_text" "$icon" "$(truncate 42 "$title")"
}

watch_clicks &

printf '{"version":1,"click_events":true}\n'
printf '[\n'

first=1
while :; do
    blocks=""

    if [ "$show_center" = true ]; then
        append_block "$(center_block "$(center_text)")"
    fi

    net=$(network_block)
    [ -n "$net" ] && append_block "$net"

    ram=$(ram_block)
    [ -n "$ram" ] && append_block "$ram"

    temp=$(temp_block)
    [ -n "$temp" ] && append_block "$temp"

    bat=$(battery_block)
    [ -n "$bat" ] && append_block "$bat"

    if [ "$first" -eq 1 ]; then
        printf '[%s]\n' "$blocks"
        first=0
    else
        printf ',[%s]\n' "$blocks"
    fi

    sleep 2
done
