#!/usr/bin/env bash
# Cycle power-profiles-daemon profile + dunst notification. Sway: $mod+Shift+p
case "$(powerprofilesctl get)" in
    performance) next=balanced ;;
    balanced)    next=power-saver ;;
    power-saver) next=performance ;;
    *)           next=balanced ;;
esac
if powerprofilesctl set "$next"; then
    notify-send -t 1500 -i "power-profile-$next" "Power Mode: ${next^}"
else
    notify-send -u critical -t 3000 "Power Mode" "Failed to set $next"
fi
