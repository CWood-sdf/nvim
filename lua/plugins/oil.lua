-- vim.api.nvim_create_autocmd("BufAdd", {
--     pattern = "oil://*",
--     callback = function()
--         vim.schedule(function()
--             vim.cmd("e ~/.config/nvim/lua/plugins/oil.lua")
--         end)
--     end,
-- })
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
            ["go"] = function()
                local entry = require('oil').get_cursor_entry()
                vim.cmd("!xdg-open \"" .. require('oil').get_current_dir() .. entry.name .. "\"")
            end
        },
    },
    -- event = "VimEnter",
    -- cmd = "Oil",
}
