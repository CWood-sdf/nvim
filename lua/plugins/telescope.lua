return {
	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			-- downloads a prebuilt binary or falls back to cargo build
			require("fff.download").download_or_build_binary()
		end,
		-- for nixos:
		-- build = "nix run .#release",
		opts = {
			debug = {
				-- enabled = true,
				-- show_scores = true,
			},
		},
		-- dev = require("stuff.isdev")("fff.nvim"),
		lazy = false, -- the plugin lazy-initialises itself
		keys = {
			-- {
			-- 	"<leader>Lf",
			-- 	function()
			-- 		require("fff").find_files()
			-- 	end,
			-- 	desc = "FFFind files",
			-- },
			-- {
			-- 	"<leader>Lg",
			-- 	function()
			-- 		require("fff").live_grep()
			-- 	end,
			-- 	desc = "LiFFFe grep",
			-- },
			-- {
			-- 	"<leader>Lz",
			-- 	function()
			-- 		require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
			-- 	end,
			-- 	desc = "Live fffuzy grep",
			-- },
			-- {
			-- 	"<leader>Lc",
			-- 	function()
			-- 		require("fff").live_grep({ query = vim.fn.expand("<cword>") })
			-- 	end,
			-- 	desc = "Search current word",
			-- },
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		keys = "<leader>f",
		-- version = "0.1.3",
		config = function()
			require("telescope").setup({
				extensions = {
					fzf = {},
				},
			})
			require("telescope").load_extension("fzf")
		end,
		-- or                            , branch = '0.1.x',
		dependencies = {
			{ "dmtrKovalenko/fff.nvim" },
			{
				"nvim-lua/plenary.nvim",
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
				},
			},
		},
		init = function()
			local wk = require("stuff.wkutils")
			wk.makeGroup("n", "<leader>f", "[F]ind", function(remap)
				remap("f", "[F]iles", function()
					require("fff").find_files()
					-- require("telescope.builtin").find_files()
				end)
				remap("q", "[F]iles", function()
					-- require("fff").find_files()
					require("telescope.builtin").find_files()
				end)
				remap("x", "[F]iles", function()
					require("telescope.builtin").find_files({
						cwd = vim.fn.stdpath("config"),
					})
				end)
				remap("F", "[F]iles no ignore", function()
					require("telescope.builtin").find_files({ no_ignore = true, hidden = true })
				end)
				remap("p", "[p]roject", function()
					require("telescope").load_extension("spaceport")
					require("telescope").extensions.spaceport.projects()
				end)
				remap("P", "New [P]roject", function()
					require("telescope").load_extension("spaceport")
					require("telescope").extensions.spaceport.find()
				end)
				remap("S", "[S]tring no ignore", function()
					require("telescope.builtin").live_grep({ no_ignore = true, hidden = true })
				end)
				remap("s", "[S]tring", function()
					-- require("stuff.multigrep")()
					require("fff").live_grep()
				end)
				remap("w", "[S]tring", function()
					require("stuff.multigrep")()
					-- require("fff").live_grep()
				end)
				remap("b", "[B]uffer", function()
					require("telescope.builtin").buffers()
				end)
				remap("h", "[H]elp", function()
					require("telescope.builtin").help_tags()
				end)
				remap("c", "[C]ommands", function()
					require("telescope.builtin").commands()
				end)
				remap("t", "[T]ags", function()
					require("telescope.builtin").tags()
				end)
				remap("r", "[R]ecent file", function()
					require("telescope.builtin").oldfiles()
				end)
				remap("g", "[G]it files", function()
					require("telescope.builtin").git_files()
				end)
				remap("R", "[R]ef", function()
					require("telescope").load_extension("taiga")
					require("telescope").extensions.taiga.refs()
				end)
				remap("e", "Th[e]me", function()
					vim.cmd("Lazy! load pineapple")
					require("telescope").load_extension("pineapple")
					require("telescope").extensions.pineapple.colorschemes()
				end)
			end)
			wk.writeBuf()
		end,
	},
	-- {
	--     "2KAbhishek/nerdy.nvim",
	--     cmd = "Nerdy",
	--     depends = { "nvim-telescope/telescope.nvim" },
	-- },
}
