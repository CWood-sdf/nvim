vim.keymap.set("n", "dd", function()
    local curqfidx = vim.fn.line('.')
    local qfall = vim.fn.getqflist()
    local count = 0
    while count < vim.v.count1 do
        if curqfidx > #qfall then
            break
        end
        table.remove(qfall, curqfidx)
        count = count + 1
    end
    vim.fn.setqflist(qfall, 'r')
    vim.api.nvim_win_set_cursor(0, { curqfidx, 0 })
end, {
    buffer = 0,
})

vim.keymap.set("v", "d", function()
    local esc = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'x', false)
    local start = vim.api.nvim_buf_get_mark(0, '<')[1]
    local finish = vim.api.nvim_buf_get_mark(0, '>')[1]
    local qfall = vim.fn.getqflist()
    local count = 0
    while count <= finish - start do
        table.remove(qfall, start)
        count = count + 1
    end
    vim.fn.setqflist(qfall, 'r')
    vim.api.nvim_win_set_cursor(0, { start, 0 })
end, {
    buffer = 0,
})
