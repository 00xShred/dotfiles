#!/bin/bash

# This script changes the brightness and sends a notification.
# Usage: ./brightness.sh up
#        ./brightness.sh down

# Use brightnessctl to change brightness
case $1 in
up)
  brightnessctl set 5%+
  ;;
down)
  brightnessctl set 5%-
  ;;
esac

# Get current brightness percentage
CURRENT=$(brightnessctl g)
MAX=$(brightnessctl m)
PERCENT=$((CURRENT * 100 / MAX))

# Send notification with a progress bar
dunstify -a "brightness" -h string:x-dunst-stack-tag:brightness -h int:value:"$PERCENT" -i display-brightness -u low "Brightness: ${PERCENT}%"
