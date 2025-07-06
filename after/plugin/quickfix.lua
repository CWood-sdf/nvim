vim.keymap.set("n", "<C-j>", function()
    if vim.iter(vim.fn.getwininfo()):any(function(wininf) return wininf.quickfix == 1 end) then
        vim.cmd("cnext")
    end
end, {})
vim.keymap.set("n", "<C-k>", function()
    if vim.iter(vim.fn.getwininfo()):any(function(wininf) return wininf.quickfix == 1 end) then
        vim.cmd("cprev")
    end
end, {})
