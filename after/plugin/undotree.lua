local wk = require("stuff.wkutils")
wk.remapNoGroup('n', '<leader>u', "Toggle Undotree", function()
    vim.cmd.UndotreeToggle()
end)
local undo = function(count)
    if (count == nil) then
        count = 1
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(count .. "u", true, true, true), "n", false)
end
local redo = function(count)
    if (count == nil) then
        count = 1
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(count .. "<C-r>", true, true, true), "n", false)
end
wk.remapNoGroup('n', '<C-z>', 'Undo', function()
    undo(vim.v.count)
end)

wk.remapNoGroup('n', '<C-y>', 'Redo', function()
    redo(vim.v.count)
end)

wk.remapNoGroup('i', '<C-z>', 'Undo', function()
    vim.cmd('stopinsert')
    undo(1)
end)

wk.remapNoGroup('i', '<C-y>', 'Redo', function()
    vim.cmd('stopinsert')
    redo(1)
end)
wk.writeBuf()
