-- ~/.config/hypr/lua/bindings/keys.lua
local hl = _G.hl
local mainMod = "SUPER"

-- Basic bindings
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nemo"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd("kitty -e yazi"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("kitty -e aerc"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty -e taskwarrior-tui"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("zen-browser"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("qutebrowser"))
hl.bind(mainMod .. " + SHIFT + ALT + B", hl.dsp.exec_cmd("~/.scripts/qutebw.sh"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(
	mainMod .. " + D",
	hl.dsp.exec_cmd('wofi --show drun --lines 3 --width 500 --allow-images --no-actions --prompt ""')
)
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd('kitty --class wallpaper_selector -e "$HOME/.scripts/wallpaper.sh"'))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast save area - | swappy -f -"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.scripts/powermenu.sh"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("nwg-displays"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("~/.scripts/volume.sh mute"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("~/.scripts/clipmenu.sh"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.scripts/quick_note.sh"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("kitty --class floating_note ~/.scripts/qn_search.sh"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("~/.scripts/clip_to_note.sh"))

-- System & Navigation
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + R", function()
    hl.exec_cmd("hyprctl reload")
    hl.exec_cmd("killall waybar; waybar &")
    hl.exec_cmd("notify-send 'Hyprland' 'Config and Waybar Reloaded'")
end)

-- Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Workspaces
for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind("ALT + TAB", function()
	hl.dsp.dispatch("cyclenext")
end)
hl.bind("ALT + SHIFT + TAB", function()
	hl.dsp.dispatch("cyclenext", "prev")
end)
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "previous" }))

-- Resize
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -20, y = 0 }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 20, y = 0 }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -20 }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 20 }))

-- Swap
hl.bind(mainMod .. " + SHIFT + H", function()
	hl.dsp.dispatch("swapwindow", "l")
end)
hl.bind(mainMod .. " + SHIFT + L", function()
	hl.dsp.dispatch("swapwindow", "r")
end)
hl.bind(mainMod .. " + SHIFT + K", function()
	hl.dsp.dispatch("swapwindow", "u")
end)
hl.bind(mainMod .. " + SHIFT + J", function()
	hl.dsp.dispatch("swapwindow", "d")
end)

-- Floating
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Mouse bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media & System keys
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.scripts/volume.sh up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.scripts/volume.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.scripts/volume.sh mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.scripts/brightness.sh up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.scripts/brightness.sh down"), { locked = true, repeating = true })
