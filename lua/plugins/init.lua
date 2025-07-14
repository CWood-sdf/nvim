return {

    {
        "folke/lazy.nvim",
    },

    {
        "CWood-sdf/taiga.nvim",
        dev = require("stuff.isdev")("taiga.nvim"),
        opts = {},
        cmd = "TaigaUi"
    },

    -- just fancy icons for dap
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    { -- Optional
        "williamboman/mason.nvim",
        opts = {},
        lazy = true,
        cmd = "Mason",
    },
    {
        "CWood-sdf/cmdTree.nvim",
        opts = {
            DEBUG = true,
        },
        dev = require("stuff.isdev")("cmdTree.nvim"),
        lazy = false,
    },
    {
        'tpope/vim-sleuth',
        event = "BufReadPre",
    },
    {
        'folke/noice.nvim',
        opts = {},
        enabled = false,
    },
}
