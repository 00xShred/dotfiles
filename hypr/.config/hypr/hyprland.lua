-- hyprland.lua
-- Main entry point for modular Lua configuration

-- Set up package path to find our modules
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/hypr/lua/?.lua"

-- Load Modules
require("core.settings")
require("core.autostart")
require("bindings.keys")
require("bindings.rules")

-- Load Plugins
require("plugins.session")

