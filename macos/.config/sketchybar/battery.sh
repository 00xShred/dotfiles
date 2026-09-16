#!/bin/bash
pct=$(pmset -g batt | awk -F '[%;]' 'NR==2 {print $2}')
/opt/local/bin/sketchybar --set "$NAME" label="${pct:-?}%"
