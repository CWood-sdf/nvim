return {
    "stevearc/oil.nvim",
    opts = {
        view_options = {
            show_hidden = true,
        },
        -- skip_confirm_for_all_edits = true,
        keymaps = {
            ["<C-s>"] = function()
                vim.cmd.w()
            end,
        },
    },
    cmd = "Oil",
}
