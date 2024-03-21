return {
    -- line at bottom
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     lazy = false,
    --     dev = true,
    --     -- event = "VeryLazy",
    --     config = function()
    --         require("lualine").setup(require('stuff.lualine'))
    --     end,
    -- },

    -- just fancy icons for dap
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    { -- Optional
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "CWood-sdf/cmdTree.nvim",
        opts = {
            DEBUG = true,
        },
        dev = true,
        lazy = false,
    },

    -- {
    --     "folke/noice.nvim",
    --     opts = {},
    --     dependencies = {
    --         "MunifTanjim/nui.nvim",
    --         -- OPTIONAL:
    --         --   `nvim-notify` is only needed, if you want to use the notification view.
    --         --   If not available, we use `mini` as the fallback
    --         "rcarriga/nvim-notify",
    --     },
    --
    -- },

}
