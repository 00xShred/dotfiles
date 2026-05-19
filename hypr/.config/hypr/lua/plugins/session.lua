-- ~/.config/hypr/lua/plugins/session.lua
local hl = _G.hl
local M = {}

function M.lock()
    hl.exec_cmd("hyprlock")
end

-- Re-bind the lock key
local mainMod = "SUPER"
hl.bind(mainMod .. " + ALT + L", function() M.lock() end)

return M
