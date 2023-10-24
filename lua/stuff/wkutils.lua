local whichkey = require('which-key')

local M = {}


M.remaps = {};
local currentGroup = "";
local currentGroupMode = "";




local remap = function(key, desc, func, opts)
    opts = opts or {}
    local keys = currentGroup .. key
    M.remaps[currentGroupMode][keys] = { func, desc }
    for k, v in pairs(opts) do
        M.remaps[currentGroupMode][keys][k] = v
    end
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
M.makeGroup = function(mode, key, desc, makeRemaps, opts)
    if (M.remaps[mode] == nil) then
        M.remaps[mode] = {}
    end
    M.remaps[mode][key] = {
        name = desc
    }
    if opts ~= nil then
        for k, v in pairs(opts) do
            M.remaps[mode][key][k] = v
        end
    end
    currentGroup = key
    currentGroupMode = mode

    if (makeRemaps ~= nil) then
        makeRemaps(remap)
    end
end
M.useGroup = function(mode, key, makeRemaps)
    if (M.remaps[mode] == nil) then
        error("Can't use group " .. key .. " in mode " .. mode .. " because it doesn't exist")
    end
    currentGroup = key
    currentGroupMode = mode

    if (makeRemaps ~= nil) then
        makeRemaps(remap)
    end
end


M.remapNoGroup = function(mode, key, desc, func, opts)
    opts = opts or {}
    if (M.remaps[mode] == nil) then
        M.remaps[mode] = {}
    end
    M.remaps[mode][key] = { func, desc }
    for k, v in pairs(opts) do
        M.remaps[mode][key][k] = v
    end
end


M.writeBuf = function()
    for k, v in pairs(M.remaps) do
        local opts = {}
        opts.mode = k
        whichkey.register(v, opts)
    end
end

return M;
