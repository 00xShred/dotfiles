#!/bin/bash

# Set the alert threshold (85%)
THRESHOLD=85

while true; do
  # Get current usage percentage of Root (/)
  CURRENT=$(df / --output=pcent | tail -n 1 | tr -dc '0-9')

  # Compare
  if [ "$CURRENT" -ge "$THRESHOLD" ]; then
    dunstify -a system -u critical \
      -h string:x-dunst-stack-tag:disk-space \
      -i drive-harddisk "Low disk space" "Root partition is ${CURRENT}% full."
  fi

  # Sleep for 1 hour (3600 seconds) before checking again
  sleep 3600
done
