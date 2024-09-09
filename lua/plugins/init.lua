return {
    {
        "nosduco/remote-sshfs.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require('remote-sshfs').setup({})
            require('telescope').load_extension('remote-sshfs')
        end,
        cmd = "RemoteSSHFSConnect"
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree"
    },
    {
        "folke/lazy.nvim",
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
        "arithran/vim-delete-hidden-buffers",
        cmd = "DeleteHiddenBuffers",
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
    -- },
}
