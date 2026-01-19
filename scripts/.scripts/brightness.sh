#!/bin/bash

# Increment/Decrement
STEP=5

case $1 in
up)
  brightnessctl set ${STEP}%+
  ;;
down)
  brightnessctl set ${STEP}%-
  ;;
esac

# Calculate percentage
CURRENT=$(brightnessctl g)
MAX=$(brightnessctl m)
PERCENT=$((CURRENT * 100 / MAX))

dunstify -a "brightness" \
  -h string:x-dunst-stack-tag:brightness \
  -h int:value:"$PERCENT" \
  -i display-brightness-symbolic \
  -u low "Brightness: ${PERCENT}%"
