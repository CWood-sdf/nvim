local wk = require("stuff.wkutils")

vim.g.mapleader = " ";
wk.makeGroup("n", "<leader>b", "[B]uf", function(remap)
    remap("n", "[N]umber", function()
        print(vim.api.nvim_get_current_buf())
    end)
end)
wk.makeGroup("n", "<leader>p", '[P]roject', function(remap)
    remap('v', '[V]iew', vim.cmd.Ex)
end)

wk.remapNoGroup("i", "<C-s>", "Save file", function()
    vim.cmd('stopinsert')
    vim.api.nvim_command('write');
end)
wk.remapNoGroup("n", "<C-s>", "Save file", function()
    vim.api.nvim_command('write');
end)
wk.makeGroup('n', '<leader>d', '[D]ebug', function(remap)
    remap('b', '[B]reakpoint', vim.cmd.DapToggleBreakpoint)
    remap('c', '[C]ontinue (<F5>)', vim.cmd.DapContinue)
    remap('i', 'Step [I]nto (<F11>)', vim.cmd.DapStepInto)
    remap('o', 'Step [O]ut (<F12>)', vim.cmd.DapStepOut)
    remap('s', '[S]tep Over (<F10>)', vim.cmd.DapStepOver)
end)


-- somehow i accidentally broke the enter key but control enter still worked
-- so i just made it so that enter is control enter
-- idk wtf happened
vim.keymap.set("i", "<CR>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-CR>", true, true, true), "i", true)
end)

wk.remapNoGroup('v', '<leader>k', 'Move selected up', function()
    local count = 0
    if (vim.v.count ~= nil) then
        count = vim.v.count
    end
    if (vim.v.count == 0) then
        count = 1
    end
    count = count + 1
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":m '>-" .. count .. "<CR>", true, true, true), "v", true)
end)
wk.remapNoGroup('v', '<leader>j', 'Move selected down', function()
    local count = 0
    if (vim.v.count ~= nil) then
        count = vim.v.count
    end
    if (vim.v.count == 0) then
        count = 1
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":m '>+" .. count .. "<CR>", true, true, true), "v", true)
end)
wk.remapNoGroup("v", "D", "Void delete", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"_d", true, true, true), "v", true)
end)
wk.remapNoGroup("v", "Y", "Yank reg x", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xy", true, true, true), "v", true)
end)
wk.remapNoGroup("o", "Y", "Yank reg x", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xy", true, true, true), "o", true)
end)
wk.remapNoGroup("x", "Y", "Yank reg x", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xy", true, true, true), "x", true)
end)
wk.remapNoGroup("v", "P", "Paste reg x", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xp", true, true, true), "v", true)
end)
wk.remapNoGroup("x", "D", "Void delete", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"_d", true, true, true), "x", true)
end)
wk.remapNoGroup("x", "P", "Paste reg x", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xp", true, true, true), "x", true)
end)
wk.remapNoGroup("o", "D", "Void delete", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"_d", true, true, true), "o", true)
end)
wk.remapNoGroup("o", "P", "Paste reg x", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xp", true, true, true), "o", true)
end)


wk.writeBuf()
