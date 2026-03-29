return {
	"nvim-treesitter/nvim-treesitter",
	-- lazy = false,
	event = { "BufReadPre", "User SpaceportDone" },
	-- event = { "VeryLazy" },
	cmd = { "TSInstall", "TSUpdate", "TSUninstall" },
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
		},
	},
	branch = "main",
	build = ":TSUpdate",
	-- tag = "v0.9.3",
	config = function()
		-- require("nvim-treesitter.install").compilers = { "clang", "zig" }

		-- local selectTextObjects = {}
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "*" },
			callback = function(ev)
				if vim.api.nvim_buf_line_count(0) > 20000 then
					return
				end
				pcall(function()
					vim.treesitter.start()
				end)
			end,
		})

		require("nvim-treesitter").setup({
			modules = {},

			ignore_install = {},

			-- A list of parser names, or "all" (the five listed parsers should always be installed)
			ensure_installed = {
				"markdown",
				"bash",
				"rust",
				"zig",
				"c",
				"javascript",
				"typescript",
				"lua",
				"vim",
				"vimdoc",
				"query",
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,
			-- textobjects = {},
		})

		require("nvim-treesitter-textobjects").setup({
			swap = {
				enable = true,
			},
			disable = function(_, bufnr) -- Disable in large C++ buffers
				return vim.api.nvim_buf_line_count(bufnr) > 20000
			end,
			select = {
				disable = function(_, bufnr) -- Disable in large C++ buffers
					return vim.api.nvim_buf_line_count(bufnr) > 20000
				end,
				enable = true,

				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,

				-- You can choose the select mode (default is charwise 'v')
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * method: eg 'v' or 'o'
				-- and should return the mode ('v', 'V', or '<c-v>') or a table
				-- mapping query_strings to modes.
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "V", -- blockwise
				},
				-- If you set this to `true` (default is `false`) then any textobject is
				-- extended to include preceding or succeeding whitespace. Succeeding
				-- whitespace has priority in order to act similarly to eg the built-in
				-- `ap`.
				--
				-- Can also be a function which gets passed a table with the keys
				-- * query_string: eg '@function.inner'
				-- * selection_mode: eg 'v'
				-- and should return true of false
				-- include_surrounding_whitespace = true,
			},
			move = {
				disable = function(_, bufnr) -- Disable in large C++ buffers
					return vim.api.nvim_buf_line_count(bufnr) > 20000
				end,
				enable = true,
			},
		})

		local tos = require("nvim-treesitter-textobjects.select")
		local function addTextObject(key, query, desc, around, inner)
			if around then
				vim.keymap.set({ "x", "o" }, "a" .. key, function()
					tos.select_textobject(query .. ".outer", "textobjects")
				end, { desc = desc })
				-- selectTextObjects["a" .. key] = { query = query .. ".outer", desc = desc }
			end
			if inner then
				vim.keymap.set({ "x", "o" }, "i" .. key, function()
					tos.select_textobject(query .. ".inner", "textobjects")
				end, { desc = desc })
				-- selectTextObjects["i" .. key] = { query = query .. ".inner", desc = desc }
			end
		end
		addTextObject("f", "@function", "Function", true, true)
		addTextObject("c", "@class", "Class", true, true)
		addTextObject("s", "@scope", "Scope", true, true)
		addTextObject("a", "@parameter", "Parameter", true, true)
		addTextObject("l", "@loop", "Loop", true, true)
		addTextObject("i", "@conditional", "Conditional", true, true)

		vim.keymap.set("n", "<leader>sj", function()
			require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
		end)
		vim.keymap.set("n", "<leader>sk", function()
			require("nvim-treesitter-textobjects.swap").swap_next("@parameter.innter")
		end)

		local tom = require("nvim-treesitter-textobjects.move")

		vim.keymap.set({ "n", "x", "o" }, "]f", function()
			tom.goto_next_start("@function.outer", "textobjects")
		end, { desc = "Next function" })
		vim.keymap.set({ "n", "x", "o" }, "]c", function()
			tom.goto_next_start("@class.outer", "textobjects")
		end, { desc = "Next class" })
		vim.keymap.set({ "n", "x", "o" }, "]l", function()
			tom.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
		end, { desc = "Next loop" })
		vim.keymap.set({ "n", "x", "o" }, "]s", function()
			tom.goto_next_start("@scope", "locals")
		end, { desc = "Next scope" })
		vim.keymap.set({ "n", "x", "o" }, "]z", function()
			tom.goto_next_start("@fold", "folds")
		end, { desc = "Next fold" })
		vim.keymap.set({ "n", "x", "o" }, "]i", function()
			tom.goto_next_start("@conditional.outer", "textobjects")
		end, { desc = "Next conditional" })

		vim.keymap.set({ "n", "x", "o" }, "]F", function()
			tom.goto_next_end("@function.outer", "textobjects")
		end, { desc = "Next function" })
		vim.keymap.set({ "n", "x", "o" }, "]C", function()
			tom.goto_next_end("@class.outer", "textobjects")
		end, { desc = "Next class" })
		vim.keymap.set({ "n", "x", "o" }, "]L", function()
			tom.goto_next_end({ "@loop.inner", "@loop.outer" }, "textobjects")
		end, { desc = "Next loop" })
		vim.keymap.set({ "n", "x", "o" }, "]S", function()
			tom.goto_next_end("@scope", "locals")
		end, { desc = "Next scope" })
		vim.keymap.set({ "n", "x", "o" }, "]Z", function()
			tom.goto_next_end("@fold", "folds")
		end, { desc = "Next fold" })
		vim.keymap.set({ "n", "x", "o" }, "]I", function()
			tom.goto_next_end("@conditional.outer", "textobjects")
		end, { desc = "Next conditional" })

		vim.keymap.set({ "n", "x", "o" }, "[f", function()
			tom.goto_next_end("@function.outer", "textobjects")
		end, { desc = "Previous function" })
		vim.keymap.set({ "n", "x", "o" }, "[c", function()
			tom.goto_next_end("@class.outer", "textobjects")
		end, { desc = "Previous class" })
		vim.keymap.set({ "n", "x", "o" }, "[l", function()
			tom.goto_next_end({ "@loop.inner", "@loop.outer" }, "textobjects")
		end, { desc = "Previous loop" })
		vim.keymap.set({ "n", "x", "o" }, "[s", function()
			tom.goto_next_end("@scope", "locals")
		end, { desc = "Previous scope" })
		vim.keymap.set({ "n", "x", "o" }, "[z", function()
			tom.goto_next_end("@fold", "folds")
		end, { desc = "Previous fold" })
		vim.keymap.set({ "n", "x", "o" }, "[i", function()
			tom.goto_next_end("@conditional.outer", "textobjects")
		end, { desc = "Previous conditional" })

		vim.keymap.set({ "n", "x", "o" }, "[F", function()
			tom.goto_next_end("@function.outer", "textobjects")
		end, { desc = "Previous function" })
		vim.keymap.set({ "n", "x", "o" }, "[C", function()
			tom.goto_next_end("@class.outer", "textobjects")
		end, { desc = "Previous class" })
		vim.keymap.set({ "n", "x", "o" }, "[L", function()
			tom.goto_next_end({ "@loop.inner", "@loop.outer" }, "textobjects")
		end, { desc = "Previous loop" })
		vim.keymap.set({ "n", "x", "o" }, "[S", function()
			tom.goto_next_end("@scope", "locals")
		end, { desc = "Previous scope" })
		vim.keymap.set({ "n", "x", "o" }, "[Z", function()
			tom.goto_next_end("@fold", "folds")
		end, { desc = "Previous fold" })
		vim.keymap.set({ "n", "x", "o" }, "[I", function()
			tom.goto_next_end("@conditional.outer", "textobjects")
		end, { desc = "Previous conditional" })

		---@class idk
		local parser_config = require("nvim-treesitter.parsers")

		parser_config.ziggy = {
			install_info = {
				url = "https://github.com/kristoff-it/ziggy",
				includes = { "tree-sitter-ziggy/src" },
				files = { "tree-sitter-ziggy/src/parser.c" },
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "ziggy",
		}
		vim.treesitter.language.register("ziggy", "ziggy")

		parser_config.ziggy_schema = {
			install_info = {
				url = "https://github.com/kristoff-it/ziggy",
				files = { "tree-sitter-ziggy-schema/src/parser.c" },
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "ziggy-schema",
		}
		vim.treesitter.language.register("ziggy_schema", "ziggy_schema")

		parser_config.supermd = {
			install_info = {
				url = "https://github.com/kristoff-it/supermd",
				includes = { "tree-sitter/supermd/src" },
				files = {
					"tree-sitter/supermd/src/parser.c",
					"tree-sitter/supermd/src/scanner.c",
				},
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "supermd",
		}
		vim.treesitter.language.register("supermd", "supermd")

		parser_config.supermd_inline = {
			install_info = {
				url = "https://github.com/kristoff-it/supermd",
				includes = { "tree-sitter/supermd-inline/src" },
				files = {
					"tree-sitter/supermd-inline/src/parser.c",
					"tree-sitter/supermd-inline/src/scanner.c",
				},
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "supermd_inline",
		}
		vim.treesitter.language.register("supermd_inline", "supermd_inline")

		parser_config.superhtml = {
			install_info = {
				url = "https://github.com/kristoff-it/superhtml",
				includes = { "tree-sitter-superhtml/src" },
				files = {
					"tree-sitter-superhtml/src/parser.c",
					"tree-sitter-superhtml/src/scanner.c",
				},
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "superhtml",
		}
		vim.treesitter.language.register("superhtml", "superhtml")

		require("banana").initTsParsers()
		vim.treesitter.language.register("yuhh", "yuhh")
		---@diagnostic disable-next-line: inject-field
		parser_config.yuhh = {
			install_info = {
				url = os.getenv("HOME") .. "/projects/tree-sitter-yuhh", -- local path or git repo
				files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
				-- optional entries:
				branch = "main", -- default branch in case of git repo if different from master
				generate_requires_npm = false, -- if stand-alone parser without npm dependencies
				requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
			},
			filetype = "yuhh", -- if filetype does not match the parser name
		}
		vim.treesitter.language.register("maple", "maple")
		---@diagnostic disable-next-line: inject-field
		parser_config.maple = {
			install_info = {
				url = os.getenv("HOME") .. "/projects/Maple/tree-sitter-maple", -- local path or git repo
				files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
				-- optional entries:
				branch = "main", -- default branch in case of git repo if different from master
				generate_requires_npm = false, -- if stand-alone parser without npm dependencies
				requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
			},
			filetype = "maple", -- if filetype does not match the parser name
		}
		vim.treesitter.language.register("pplang", "pplang")
		---@diagnostic disable-next-line: inject-field
		parser_config.pplang = {
			install_info = {
				url = os.getenv("HOME") .. "/projects/pplang/tree-sitter-pplang", -- local path or git repo
				files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
				-- optional entries:
				branch = "main", -- default branch in case of git repo if different from master
				generate_requires_npm = false, -- if stand-alone parser without npm dependencies
				requires_generate_from_grammar = true, -- if folder contains pre-generated src/parser.c
			},
			filetype = "pplang", -- if filetype does not match the parser name
		}
	end,
}
