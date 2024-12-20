local term = {
    win = -1,
    buf = -1,
}


vim.api.nvim_create_user_command("Floaterminal", function()
    if not vim.api.nvim_buf_is_valid(term.buf) then
        term.buf = vim.api.nvim_create_buf(false, true)
    end
    if not vim.api.nvim_win_is_valid(term.win) then
        term.win = vim.api.nvim_open_win(term.buf, true, {
            relative = "editor",
            -- style = "minimal",
            row = math.floor(vim.o.lines * 0.1),
            col = math.floor(vim.o.columns * 0.1),
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.8),
            border = "rounded",
        })
        -- vim.api.nvim_set_option_value("number", true, { win = term.win })
        -- vim.api.nvim_set_option_value("relativenumber", true, { win = term.win })
        vim.api.nvim_set_option_value("signcolumn", "no", { win = term.win })
        if vim.bo[term.buf].buftype ~= "terminal" then
            vim.cmd.term()
        end
        vim.cmd.startinsert()
    elseif vim.api.nvim_get_current_win() == term.win then
        vim.api.nvim_win_hide(term.win)
    else
        vim.api.nvim_set_current_win(term.win)
    end
end, {})
