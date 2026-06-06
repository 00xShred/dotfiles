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
logout="󰗽  Logout"

# Detect desktop environment
if [ "$XDG_CURRENT_DESKTOP" = "dwl" ]; then
  LOCK_CMD="swaylock -f"
  LOGOUT_CMD="uwsm stop || pkill -x dwl"
else
  LOCK_CMD="hyprlock"
  LOGOUT_CMD="hyprctl dispatch exit 0"
fi

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
  $LOCK_CMD &
  sleep 0.1
  systemctl suspend
  ;;
"$lock")
  $LOCK_CMD
  ;;
"$logout")
  eval "$LOGOUT_CMD"
  ;;
esac
