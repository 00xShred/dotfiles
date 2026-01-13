#!/bin/bash

# This script changes the volume and sends a notification.
# Usage: ./volume.sh up
#        ./volume.sh down
#        ./volume.sh mute

# Use pamixer to change volume
case $1 in
up)
  pamixer -i 5
  ;;
down)
  pamixer -d 5
  ;;
mute)
  pamixer -t
  ;;
esac

# Check if muted
if pamixer --get-mute | grep -q "true"; then
  # Send a "Muted" notification
  dunstify -a "volume" -h string:x-dunst-stack-tag:volume -i audio-volume-muted -u low "Volume Muted"
else
  # Get current volume
  VOLUME=$(pamixer --get-volume)

  # Send notification with a progress bar
  # -h int:value:$VOLUME creates the bar
  # -h string:x-dunst-stack-tag:volume makes notifications replace each other
  dunstify -a "volume" -h string:x-dunst-stack-tag:volume -h int:value:"$VOLUME" -i audio-volume-high -u low "Volume: ${VOLUME}%"
fi
