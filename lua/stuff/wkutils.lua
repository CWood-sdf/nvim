local whichkey = require('which-key')

local M = {}


M.remaps = {};
local currentGroup = "";
local currentGroupMode = "";


local remap = function(key, desc, func, opts)
    local keys = currentGroup .. key
    M.remaps[currentGroupMode][keys] = { func, desc, opts }
end

M.makeGroup = function(mode, key, desc, makeRemaps)
    if (M.remaps[mode] == nil) then
        M.remaps[mode] = {}
    end
    M.remaps[mode][key] = {
        name = desc
    }
    currentGroup = key
    currentGroupMode = mode

    if (makeRemaps ~= nil) then
        makeRemaps(remap)
    end
end


M.remapNoGroup = function(mode, key, desc, func, opts)
    if (M.remaps[mode] == nil) then
        M.remaps[mode] = {}
    end
    M.remaps[mode][key] = { func, desc, opts }
end

M.useGroup = function(group, makeRemaps)
    currentGroup = group
    if (makeRemaps ~= nil) then
        makeRemaps(remap)
    end
end

M.writeBuf = function()
    for k, v in pairs(M.remaps) do
        whichkey.register(v, {
            mode = k,
        })
    end
end

return M;