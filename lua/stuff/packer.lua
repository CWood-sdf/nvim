-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local ensure_packer = function()
    local fn = vim.fn
    print("bootstrapping...")
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

-- Auto compile when there are changes in packer.lua
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerCompile
  augroup end
]])
return require('packer').startup(function(use)
    --formatter
    use { 'mhartington/formatter.nvim' }
    --theme
    use {
        'folke/tokyonight.nvim',
        config = function()
            require('tokyonight').setup()
        end
    }

    -- line at bottom
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    }

    -- just fancy icons for dap
    use 'nvim-tree/nvim-web-devicons'

    --autocomment
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- remember keymaps
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

    -- Debugger stuff
    use {
        "rcarriga/nvim-dap-ui",
        requires = { "mfussenegger/nvim-dap" },
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

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- fuzzy finder
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        { run = ':TSUpdate' }
    }

    use {
        'nvim-treesitter/playground'
    }
    -- epic fast file goto
    use {
        'ThePrimeagen/harpoon'
    }

    -- undotree
    use 'mbbill/undotree'

    -- git
    use 'tpope/vim-fugitive'

    -- lsp
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
    }

    -- copilot
    use 'github/copilot.vim'

    if packer_bootstrap then
        require('packer').sync()
    end
end)
