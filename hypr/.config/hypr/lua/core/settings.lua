-- ~/.config/hypr/lua/core/settings.lua
local hl = _G.hl
local helpers = require("core.helpers")
local wal = helpers.source_legacy(os.getenv("HOME") .. "/.cache/wal/colors-hyprland.conf")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GTK_THEME", "Breeze-Dark")
hl.env("GDK_SCALE", "1")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

hl.config({
	input = {
		kb_layout = "us",
		follow_mouse = 1,
		touchpad = {
			natural_scroll = true,
		},
	},
	general = {
		gaps_in = 3,
		gaps_out = 5,
		border_size = 2,
		col = {
			active_border = wal.color4 or "rgba(33ccffee)",
			inactive_border = wal.color8 or "rgba(595959aa)",
		},
		layout = "dwindle",
	},
	render = {
		cm_auto_hdr = 0,
	},
	decoration = {

		rounding = 3,
		active_opacity = 0.95,
		inactive_opacity = 0.85,
		fullscreen_opacity = 1.0,
		blur = {
			enabled = true,
			size = 3,
			passes = 2,
		},
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
	},
	animations = {
		enabled = true,
		bezier = { "myBezier", 0.05, 0.9, 0.1, 1.05 },
		animation = {
			{ "windows", 1, 7, "myBezier" },
			{ "windowsOut", 1, 7, "default", "slide" },
			{ "border", 1, 10, "default" },
			{ "fade", 1, 7, "default" },
			{ "workspaces", 1, 6, "default" },
		},
	},
	dwindle = {
		preserve_split = false,
	},
	cursor = {
		hide_on_key_press = true,
		inactive_timeout = 3,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
