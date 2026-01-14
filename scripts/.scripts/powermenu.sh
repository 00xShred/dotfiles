#!/bin/bash

# --- Wofi Configuration ---
# We use the same theme-aware, compact style as our other scripts
WOFI_CMD="wofi --dmenu -i -p Power-Menu --width 300 --lines 5"

# --- Options ---
# We use Nerd Font icons to match your setup
shutdown="⏻  Shutdown"
reboot="  Reboot"
suspend="  Suspend"
lock="  Lock"
logout="SignOut  Logout"

# Pipe the options into wofi
choice=$(printf "%s\n%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$suspend" "$lock" "$logout" | $WOFI_CMD)

# --- Action ---
case "$choice" in
"$shutdown")
  systemctl poweroff
  ;;
"$reboot")
  systemctl reboot
  ;;
"$suspend")
  # Lock the screen *before* suspending.
  hyprlock &
  sleep 0.1
  systemctl suspend
  ;;
"$lock")
  hyprlock
  ;;
"$logout")
  # This is the proper command to exit Hyprland
  hyprctl dispatch exit 0
  ;;
esac
