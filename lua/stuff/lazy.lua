-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('lazy').setup({
    {
        "stevearc/vim-arduino",
    },
    {
        "CWood-sdf/pineapple",
        dev = true,
        dependencies = require("stuff.pineapple"),
        opts = {
            installedRegistry = "stuff.pineapple",
        },
    },
    -- yuhh
    {
        "iamcco/markdown-preview.nvim",
        event = "VeryLazy",
    },
    --formatter
    {
        'mhartington/formatter.nvim',
        event = "VeryLazy"
    },

    --theme
    {
        'folke/tokyonight.nvim',
        config = function()
            require('tokyonight').setup()
        end
    },

    -- line at bottom
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
        event = "VeryLazy",
    },

    -- just fancy icons for dap
    { 'nvim-tree/nvim-web-devicons', event = "VeryLazy" },

    --autocomment
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end,
        event = "VeryLazy",
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
        event = "VeryLazy",
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "mfussenegger/nvim-dap",
            'williamboman/mason.nvim', },
        event = "VeryLazy",
    },

    {
        "mfussenegger/nvim-dap",
        event = "VeryLazy",

    },

    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        event = "VeryLazy",
        version = '0.1.1',
        -- or                            , branch = '0.1.x',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },

    -- highlighting
    {
        'nvim-treesitter/nvim-treesitter',
        event = "VeryLazy",
        build = ':TSUpdate'
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
        event = "VeryLazy",
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
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
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
        event = "VeryLazy",
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
    }
}
)
