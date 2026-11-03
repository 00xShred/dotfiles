#!/bin/bash

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

# Increment/Decrement
STEP=5

case ${1:-} in
up)
  brightnessctl set ${STEP}%+ >/dev/null
  ;;
down)
  brightnessctl set ${STEP}%- >/dev/null
  ;;
"")
  ;;
*)
  log_err "Usage: $0 [up|down]"
  exit 2
  ;;
esac

# Calculate percentage
CURRENT=$(brightnessctl g)
MAX=$(brightnessctl m)
PERCENT=$((CURRENT * 100 / MAX))

log_info "Brightness: ${PERCENT}%"

dunstify -a "brightness" \
  -h string:x-dunst-stack-tag:brightness \
  -h int:value:"$PERCENT" \
  -i display-brightness-symbolic \
  -u low "Brightness: ${PERCENT}%"
