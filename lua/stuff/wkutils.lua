local whichkey = require('which-key')

local M = {}


M.remaps = {};
local currentGroup = "";
local currentGroupMode = "";


local remap = function(key, desc, func, opts)
    local keys = currentGroup .. key
    M.remaps[currentGroupMode][keys] = { func, desc, opts }
    -- if there's a '(...)' in the desc, then remap that key to the func too
    if (desc:find('%(') ~= nil) then
        local desc2 = desc:gsub('%(.*%)', '')
        -- strip [ and ] from desc2
        desc2 = desc2:gsub('%[', '')
        desc2 = desc2:gsub('%]', '')
        local newKey = desc:match('%((.-)%)')
        M.remapNoGroup(currentGroupMode, newKey, desc2, func, opts)
    end
end

M.feedKeys = function(keys, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode, true)
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
