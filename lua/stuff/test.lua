local group = vim.api.nvim_create_augroup("P", {})
vim.api.nvim_create_autocmd("User", {
    pattern = "PineappleColorschemePre",
    group = group,
    callback = function(data)
        print("PineappleColorschemePre")
        print(vim.inspect(data))
        local file = io.open("yeet.txt", "w")
        file:close()
        file = io.open("yeet.txt", "w")
        file:write(vim.inspect(data))
        file:close()
    end,
})
