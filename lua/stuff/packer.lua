-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
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
