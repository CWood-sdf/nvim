-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require("lazy").setup({
	-- {
	-- 	"mfussenegger/nvim-lint",
	-- 	event = "BufEnter *.*",
	-- 	config = function()
	-- 		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	--
	-- 			callback = function()
	-- 				require("lint").try_lint()
	-- 			end,
	-- 		})
	-- 		require("lint").linters_by_ft = {
	-- 			javascript = { "eslint_d" },
	-- 			typescript = { "eslint_d" },
	-- 			typescriptreact = { "eslint_d" },
	-- 			json = { "jsonlint" },
	-- 			css = { "stylelint" },
	-- 			markdown = { "markdownlint", "vale" },
	-- 		}
	-- 	end,
	-- },
	{
		"stevearc/conform.nvim",
		opts = {
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 1000,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				markdown = { "prettier" },
			},
			notify_on_error = true,
		},
		event = "VeryLazy",
	},
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
	{ "folke/neodev.nvim", ft = "lua", opts = {} },
	{
		"ThePrimeagen/vim-be-good",
		cmd = "VimBeGood",
	},
	{
		"stevearc/vim-arduino",
		ft = (function()
			if jit.os == "Windows" then
				return "sdjfaksdhgksd"
			end
			return "arduino"
		end)(),
	},
	{
		"CWood-sdf/spaceport.nvim",
		opts = {
			ignoreDirs = { { "/mnt/c/Users/woodc", "_" } },
			replaceHome = true,
		},
		lazy = false,
		-- dev = true,
	},
	{
		"CWood-sdf/pineapple",
		dependencies = require("stuff.pineapple"),
		opts = {
			installedRegistry = "stuff.pineapple",
			colorschemeFile = "after/plugin/theme.lua",
		},
		priority = 1000,
		-- commit = "d2ad4b8c012eaaa37ac043d78fce2bee155efda6",
		-- dev = true
	},
	-- yuhh
	{
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
	},

	-- line at bottom
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
	},

	-- -- just fancy icons for dap
	-- {
	--     'nvim-tree/nvim-web-devicons',
	--     -- event = "VeryLazy"
	-- },

	--autocomment
	{
		"numToStr/Comment.nvim",
		event = "BufEnter *.*",
		opts = {},
	},

	-- remember keymaps
	{
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({})
		end,
		lazy = false,
	},

	-- Debugger stuff
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		lazy = true,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"mfussenegger/nvim-dap",
			"williamboman/mason.nvim",
		},
		lazy = true,
	},

	{
		"mfussenegger/nvim-dap",
		lazy = true,
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		version = "0.1.3",
		-- or                            , branch = '0.1.x',
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},

	-- highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufEnter *.*",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("stuff.ts_setup")()
		end,
		-- event = "VeryLazy",
		-- build = ':TSUpdate'
	},

	-- epic fast file goto
	{
		"ThePrimeagen/harpoon",
		event = "VeryLazy",
	},

	-- undotree
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle", "UndotreeShow" },
	},

	-- git
	{
		"tpope/vim-fugitive",
		cmd = "Git",
	},

	-- lsp
	{
		"VonHeikemen/lsp-zero.nvim",
		--branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{
				"neovim/nvim-lspconfig",
			}, -- Required
			{ -- Optional
				"williamboman/mason.nvim",
			},
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "L3MON4D3/LuaSnip" }, -- Required
			{ "rafamadriz/friendly-snippets" },
		},
		event = "BufEnter *.*",
		config = function()
			require("stuff.lsp_setup")()
		end,
	},

	-- copilot
	{
		"github/copilot.vim",
		event = "BufEnter *.*",
	},
}, {
	dev = {
		path = (function()
			if jit.os == "Windows" then
				return "C:\\Users\\woodc\\"
			end
			return "/mnt/c/Users/woodc/"
		end)(),
	},
})
