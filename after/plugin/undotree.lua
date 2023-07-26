local wk = require("stuff.wkutils")
wk.remapNoGroup('n', '<leader>u', "Toggle Undotree", vim.cmd.UndotreeToggle)
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
vim.keymap.set('n', '<C-z>', function()
    undo(vim.v.count)
end)

vim.keymap.set('n', '<C-y>', function()
    redo(vim.v.count)
end)

vim.keymap.set('i', '<C-z>', function()
    vim.cmd('stopinsert')
    undo(1)
end)

vim.keymap.set('i', '<C-y>', function()
    vim.cmd('stopinsert')
    redo(1)
end)
wk.writeBuf()
