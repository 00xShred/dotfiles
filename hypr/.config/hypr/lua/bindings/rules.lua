-- ~/.config/hypr/lua/bindings/rules.lua
local hl = _G.hl

hl.window_rule({
    name = "glow-popover",
    match = { title = "^(glow)$" },
    float = true,
    size = { 900, 600 },
    center = true,
    pin = true,
})

hl.window_rule({
    name = "wallpaper-picker",
    match = { class = "^(wallpaper_selector)$" },
    float = true,
    size = { 800, 500 },
    center = true
})

hl.window_rule({
    name = "quick-note-popover",
    match = { class = "^(floating_note)$" },
    float = true,
    size = { 900, 600 },
    center = true,
    pin = true
})

hl.layer_rule({
    name = "waybar-blur",
    match = { namespace = "waybar" },
    blur = true
})

hl.layer_rule({
    name = "wofi-style",
    match = { namespace = "wofi" },
    blur = true,
    dim_around = true
})
