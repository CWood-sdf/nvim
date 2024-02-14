return {
    -- line at bottom
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        -- event = "VeryLazy",
        config = function()
            require("stuff.lualine")
        end,
    },

    -- just fancy icons for dap
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    { -- Optional
        "williamboman/mason.nvim",
        opts = {},
    },

    -- copilot
    {
        "github/copilot.vim",
        config = function()
            vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
            if vim.fn.executable("bun") == 1 then
                vim.cmd("let g:copilot_node_command = 'bun'")
            end
            -- vim.cmd("let g:copilot_filetypes.markdown = v:true")
            vim.cmd("let g:copilot_filetypes = { 'markdown': v:true }")
        end,
        cmd = "Copilot",
    },
}
