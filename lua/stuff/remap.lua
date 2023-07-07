vim.g.mapleader = " ";
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex);
vim.keymap.set("i", "<C-s>", function()
    vim.cmd('stopinsert')
    vim.api.nvim_command('write');
end)
vim.keymap.set("n", "<C-s>", function()
    vim.api.nvim_command('write');
end)
vim.keymap.set("i", "<C-m>", function()
    vim.cmd('stopinsert')
end)

-- somehow i accidentally broke the enter key but control enter still worked
-- so i just made it so that enter is control enter
-- idk wtf happened
vim.keymap.set("i", "<CR>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-CR>", true, true, true), "i", true)
end)
vim.keymap.set("v", "<leader>k", function()
    --move selected stuff down
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
vim.keymap.set("v", "<leader>j", function()
    --move selected stuff up
    local count = 0
    if (vim.v.count ~= nil) then
        count = vim.v.count
    end
    if (vim.v.count == 0) then
        count = 1
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":m '>+" .. count .. "<CR>", true, true, true), "v", true)
end)
vim.keymap.set("v", "D", function()
    vim.prin("v")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"_d<CR>", true, true, true), "v", true)
end)
vim.keymap.set("v", "Y", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xy<CR>", true, true, true), "v", true)
end)
vim.keymap.set("o", "Y", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xy<CR>", true, true, true), "o", true)
end)
vim.keymap.set("x", "Y", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xy<CR>", true, true, true), "x", true)
end)
vim.keymap.set("v", "P", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xp<CR>", true, true, true), "v", true)
end)
vim.keymap.set("x", "D", function()
    vim.print("x")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"_d<CR>", true, true, true), "x", true)
end)
vim.keymap.set("x", "P", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xp<CR>", true, true, true), "x", true)
end)
vim.keymap.set("o", "D", function()
    vim.print("o")
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"_d<CR>", true, true, true), "o", true)
end)
vim.keymap.set("o", "P", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("\"xp<CR>", true, true, true), "o", true)
end)

-- AUTOFORMAT!!!!!
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
