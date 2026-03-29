-- vim.api.nvim_create_autocmd("FileType", {
--     group = vim.api.nvim_create_augroup("ziggy", {}),
--     pattern = "ziggy",
--     callback = function()
--         vim.lsp.start({
--             name = "Ziggy LSP",
--             cmd = { "ziggy", "lsp" },
--             root_dir = vim.loop.cwd(),
--             flags = { exit_timeout = 1000 },
--         })
--     end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--     group = vim.api.nvim_create_augroup("ziggy_schema", {}),
--     pattern = "ziggy_schema",
--     callback = function()
--         vim.lsp.start({
--             name = "Ziggy LSP",
--             cmd = { "ziggy", "lsp", "--schema" },
--             root_dir = vim.loop.cwd(),
--             flags = { exit_timeout = 1000 },
--         })
--     end,
-- })

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("superhtml", {}),
    pattern = "superhtml",
    callback = function()
        vim.lsp.start({
            name = "SuperHTML LSP",
            cmd = { "/home/christopher-wood/fun/zinetest/superhtml/zig-out/bin/superhtml", "lsp" },
            root_dir = vim.loop.cwd(),
            flags = { exit_timeout = 1000 },
        })
    end,
})

vim.filetype.add({
    extension = {
        smd = "supermd",
        shtml = "superhtml",
        ziggy = "ziggy",
        ["ziggy-schema"] = "ziggy_schema",
    },
})
