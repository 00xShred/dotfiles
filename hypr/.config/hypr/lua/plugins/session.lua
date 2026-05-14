-- ~/.config/hypr/lua/plugins/session.lua
local hl = _G.hl
local M = {}

function M.lock()
    -- Use the new CSS style and daemonize
    hl.exec_cmd("gtklock -d -s ~/.config/gtklock/style.css")
end

-- Re-bind the lock key
local mainMod = "SUPER"
hl.bind(mainMod .. " + ALT + L", function() M.lock() end)

return M
