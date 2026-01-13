#!/bin/bash

MODE=$(powerprofilesctl get)

if [ "$MODE" = "power-saver" ]; then
  ICON="󰌪"
elif [ "$MODE" = "balanced" ]; then
  ICON="⚖"
elif [ "$MODE" = "performance" ]; then
  ICON="⚡"
else
  ICON="?"
fi

# This new script returns JSON, which Waybar loves
echo "{\"text\": \"$ICON\", \"tooltip\": \"Power Profile: $MODE\"}"
