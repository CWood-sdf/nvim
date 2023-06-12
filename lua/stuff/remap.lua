vim.g.mapleader = " ";
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex);
vim.keymap.set("i", "<C-s>", function()
    vim.api.nvim_command('write');
    vim.cmd('stopinsert')
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
-- AUTOFORMAT!!!!!
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
