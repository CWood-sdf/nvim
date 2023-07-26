-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    }

    use 'nvim-tree/nvim-web-devicons'

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
        config = function()
            local dap = require('dap')
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    }

    use {
        "jay-babu/mason-nvim-dap.nvim",
        requires = {
            "mfussenegger/nvim-dap",
            'williamboman/mason.nvim', },
    }

    use {
        "mfussenegger/nvim-dap",
    }

    use 'EdenEast/nightfox.nvim'

    use 'ThePrimeagen/vim-be-good'
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        'marko-cerovac/material.nvim',
        config = function()
            vim.g.material_style = "deep ocean";
            vim.cmd 'colorscheme material'
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        { run = ':TSUpdate' }
    }

    use {
        'nvim-treesitter/playground'
    }

    use {
        'ThePrimeagen/harpoon'
    }

    use 'mbbill/undotree'

    use 'tpope/vim-fugitive'

    use {
        'VonHeikemen/lsp-zero.nvim',
        --branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
                'williamboman/mason.nvim',
                --run = function()
                --	  pcall(vim.cmd, 'MasonUpdate')
                -- end,
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
        -- use {
        --     requires = { "nvim-treesitter/nvim-treesitter" },
        --     "Badhi/nvim-treesitter-cpp-tools",
        -- }
        --
    }


    use 'github/copilot.vim'

    use { "bluz71/vim-moonfly-colors", as = "moonfly" }
end)
