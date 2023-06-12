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
-- AUTOFORMAT!!!!!
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
