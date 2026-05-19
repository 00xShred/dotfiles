-- ~/.config/hypr/lua/core/autostart.lua
local hl = _G.hl

hl.on("hyprland.start", function()
    hl.exec_cmd("notify-send 'Hyprland' 'Lua Configuration Loaded Successfully!'")
    hl.exec_cmd("uwsm finalize")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("kanshi")
    hl.exec_cmd("swaybg -i $(cat ~/.cache/wal/wal) -m fill")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
end)

