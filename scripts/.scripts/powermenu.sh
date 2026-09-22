#!/bin/bash

# --- Menu Configuration ---
MENU_CMD="fuzzel --dmenu --prompt Power-Menu>  --lines 5 --width 20"

# --- Options ---
# We use Nerd Font icons to match your setup
shutdown="⏻  Shutdown"
reboot="  Reboot"
suspend="  Suspend"
lock="  Lock"
logout="󰗽  Logout"

# Detect desktop environment
LOCK_CMD="swaylock -f"
if [ "$XDG_CURRENT_DESKTOP" = "dwl" ]; then
  LOGOUT_CMD="uwsm stop || pkill -x dwl"
else
  LOGOUT_CMD="swaymsg exit || uwsm stop"
fi

# Pipe the options into fuzzel
choice=$(printf "%s\n%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$suspend" "$lock" "$logout" | $MENU_CMD)

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
