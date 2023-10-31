-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('lazy').setup({
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {
            -- options
            window = {
                blend = 0,
            },
        },
    },
    { "folke/neodev.nvim", lazy = true },
    {
        "CWood-sdf/future.nvim",
    },
    {
        "ThePrimeagen/vim-be-good",
        event = "VeryLazy",
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        event = "VeryLazy",
    },
    {
        (function()
            if jit.os ~= "Windows" then
                return "stevearc/vim-arduino"
            end
        end)(),
        ft = "arduino"
    },
    {
        "CWood-sdf/spaceport.nvim",
        opts = {
            ignoreDirs = { { "/mnt/c/Users/woodc", "_" } },
            replaceHome = true
        },
        lazy = false
        -- dev = true,
    },
    {
        "CWood-sdf/pineapple",
        dependencies = require("stuff.pineapple"),
        opts = {
            installedRegistry = "stuff.pineapple",
            colorschemeFile = "after/plugin/theme.lua"
        },
        -- commit = "d2ad4b8c012eaaa37ac043d78fce2bee155efda6",
        -- dev = true
    },
    -- yuhh
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
    },
    --formatter
    {
        'mhartington/formatter.nvim',
        event = "VeryLazy"
    },


    -- line at bottom
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
        lazy = false
    },

    -- -- just fancy icons for dap
    -- {
    --     'nvim-tree/nvim-web-devicons',
    --     -- event = "VeryLazy"
    -- },

    --autocomment
    {
        'numToStr/Comment.nvim',
        lazy = true
    },

    -- remember keymaps
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true;
            vim.o.timeoutlen = 300;
            require("which-key").setup({
            })
        end,
        event = "VeryLazy",
    },

    -- Debugger stuff
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" },
        lazy = true
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "mfussenegger/nvim-dap",
            'williamboman/mason.nvim', },
        lazy = true
    },

    {
        "mfussenegger/nvim-dap",
        lazy = true

    },

    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        event = "VeryLazy",
        version = '0.1.3',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },

    -- highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        -- event = "VeryLazy",
        -- build = ':TSUpdate'
    },

    {
        'nvim-treesitter/playground',
        event = "VeryLazy",
    },

    -- epic fast file goto
    {
        'ThePrimeagen/harpoon',
        event = "VeryLazy",
    },

    -- undotree
    {
        'mbbill/undotree',
        cmd = { "UndotreeToggle", "UndotreeShow" },
    },

    -- git
    {
        'tpope/vim-fugitive',
        event = "VeryLazy",
    },

    -- lsp
    {
        'VonHeikemen/lsp-zero.nvim',
        --branch = 'v2.x',
        dependencies = {
            -- LSP Support
            {
                'neovim/nvim-lspconfig',
            }, -- Required
            {  -- Optional
                'williamboman/mason.nvim',
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'L3MON4D3/LuaSnip' }, -- Required
            { 'rafamadriz/friendly-snippets' }
        },
        lazy = true,
    },

    -- copilot
    {
        'github/copilot.vim',
        event = "VeryLazy"
    },

}, {
    dev = {
        path = (function()
            if jit.os == "Windows" then
                return "C:\\Users\\woodc\\"
            end
            return "/mnt/c/Users/woodc/"
        end)()
    },
}
)
