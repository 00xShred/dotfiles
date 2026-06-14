#!/bin/bash

STEP=5
SINK="@DEFAULT_AUDIO_SINK@"

case "$1" in
up)
  wpctl set-mute "$SINK" 0
  wpctl set-volume -l 1.5 "$SINK" "${STEP}%+"
  ;;
down)
  wpctl set-volume "$SINK" "${STEP}%-"
  ;;
mute)
  wpctl set-mute "$SINK" toggle
  ;;
*)
  exit 2
  ;;
esac

out=$(wpctl get-volume "$SINK") || exit 0

if printf '%s' "$out" | grep -q MUTED; then
  dunstify -a "volume" \
    -h string:x-dunst-stack-tag:volume \
    -i audio-volume-muted \
    -u low "Volume Muted"
  exit 0
fi

volume=$(printf '%s' "$out" | awk '{ for (i = 1; i <= NF; i++) if ($i ~ /^[0-9.]+$/) { printf "%d", ($i * 100) + 0.5; exit } }')
[ -n "$volume" ] || exit 0

if [ "$volume" -ge 100 ]; then
  icon="audio-volume-high"
elif [ "$volume" -ge 50 ]; then
  icon="audio-volume-medium"
elif [ "$volume" -gt 0 ]; then
  icon="audio-volume-low"
else
  icon="audio-volume-muted"
fi

dunstify -a "volume" \
  -h string:x-dunst-stack-tag:volume \
  -h int:value:"$volume" \
  -i "$icon" \
  -u low "Volume: ${volume}%"
