-- ~/.config/hypr/lua/core/helpers.lua
local M = {}

function M.source_legacy(path)
    local vars = {}
    local file = io.open(path, "r")
    if not file then return vars end

    for line in file:lines() do
        local name, value = line:match("^%s*$(%w+)%s*=%s*(.-)%s*$")
        if name and value then
            vars[name] = value
        end
    end
    file:close()
    return vars
end

return M
