return {
	"stevearc/oil.nvim",
	opts = {
		view_options = {
			show_hidden = true,
		},
		delete_to_trash = true,
		-- skip_confirm_for_all_edits = true,
		keymaps = {
			["<C-s>"] = function()
				vim.cmd.w()
			end,
			["go"] = function()
				local entry = require("oil").get_cursor_entry()
				vim.cmd('!xdg-open "' .. require("oil").get_current_dir() .. entry.name .. '"')
			end,
		},
	},
	-- event = "VimEnter",
	-- cmd = "Oil",
}
