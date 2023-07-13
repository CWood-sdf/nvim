vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

vim.keymap.set('n', '<C-z>', function()
    local count = 1
    if (vim.v.count == nil) then
        count = 1
    else
        count = vim.v.count
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(count .. "g-", true, true, true), "n", false)
end)

vim.keymap.set('n', '<C-y>', function()
    local count = 1
    if (vim.v.count == nil) then
        count = 1
    else
        count = vim.v.count
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(count .. "g+", true, true, true), "n", false)
end)

vim.keymap.set('i', '<C-z>', function()
    local count = 1
    if (vim.v.count == nil) then
        count = 1
    else
        count = vim.v.count
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(count .. "g-", true, true, true), "x!", false)
    vim.cmd('startinsert')
end)

vim.keymap.set('i', '<C-y>', function()
    local count = 1
    if (vim.v.count == nil) then
        count = 1
    else
        count = vim.v.count
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(count .. "g+", true, true, true), "x!", false)
    vim.cmd('startinsert')
end)
