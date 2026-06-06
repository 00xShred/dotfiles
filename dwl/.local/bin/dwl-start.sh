#!/bin/sh

export XDG_CURRENT_DESKTOP=dwl
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=dwl
export GTK_THEME=Breeze-Dark
export GDK_SCALE=1
export XCURSOR_THEME=Bibata-Modern-Classic
export XCURSOR_SIZE=24
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORM=wayland
export MOZ_ENABLE_WAYLAND=1

dbus-update-activation-environment --systemd \
    WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE \
    XCURSOR_THEME XCURSOR_SIZE

if command -v uwsm >/dev/null 2>&1; then
    uwsm finalize
fi

dunst &
kanshi &
swaybg -i "$(cat ~/.cache/wal/wal)" -m fill &
nm-applet --indicator &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
swayidle -w \
    timeout 300 'swaylock -f' \
    timeout 900 'systemctl suspend' \
    before-sleep 'swaylock -f' &
wlsunset -l 47.4 -L 8.5 &
gnome-keyring-daemon --start --components=secrets &

pkill -f somebar-status.sh 2>/dev/null
sleep 0.2
rm -f "$XDG_RUNTIME_DIR"/somebar-* 2>/dev/null

if [ -x "$HOME/.local/bin/somebar" ]; then
    ~/.scripts/somebar-status.sh </dev/null >/tmp/somebar-status.log 2>&1 &
    exec "$HOME/.local/bin/somebar" >/tmp/somebar.log 2>&1
elif command -v somebar >/dev/null 2>&1; then
    ~/.scripts/somebar-status.sh </dev/null >/tmp/somebar-status.log 2>&1 &
    exec somebar >/tmp/somebar.log 2>&1
fi
