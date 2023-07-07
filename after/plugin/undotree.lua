vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

vim.keymap.set('n', '<C-z>', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("g-", true, true, true), "n", true)
end)

vim.keymap.set('n', '<C-y>', function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("g+", true, true, true), "n", true)
end)
