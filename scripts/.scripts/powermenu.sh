#!/bin/bash

# shellcheck source=lib/log.sh
. "${0%/*}/lib/log.sh" 2>/dev/null || . "$HOME/.scripts/lib/log.sh"

# --- Menu Configuration ---
MENU_CMD="fuzzel --dmenu --prompt 󰐥  --lines 5 --width 20"

# --- Options ---
# Nerd Font v3 icons
shutdown="󰐥  Shutdown"
reboot="󰑐  Reboot"
suspend="󰒲  Suspend"
lock="󰌾  Lock"
logout="󰗽  Logout"

# Detect desktop environment
LOCK_CMD="swaylock -f"
if [ "$XDG_CURRENT_DESKTOP" = "dwl" ]; then
  LOGOUT_CMD="{ command -v uwsm >/dev/null && uwsm stop; } || pkill -x dwl"
else
  LOGOUT_CMD="swaymsg exit"
fi

# Pipe the options into fuzzel
choice=$(printf "%s\n%s\n%s\n%s\n%s" "$shutdown" "$reboot" "$suspend" "$lock" "$logout" | $MENU_CMD)

[ -z "$choice" ] && { log_info "Power menu dismissed"; exit 0; }

log_step "Action selected: $choice"

# --- Action ---
power_cmd() {
  if [ -d /run/systemd/system ]; then
    systemctl "$1"
  else
    loginctl "$1"
  fi
}

case "$choice" in
"$shutdown")
  power_cmd poweroff
  ;;
"$reboot")
  power_cmd reboot
  ;;
"$suspend")
  # Lock the screen *before* suspending.
  $LOCK_CMD &
  sleep 0.1
  power_cmd suspend
  ;;
"$lock")
  $LOCK_CMD
  ;;
"$logout")
  eval "$LOGOUT_CMD"
  ;;
esac
