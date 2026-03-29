return {
	"tpope/vim-fugitive",
	cmd = "Git",
	event = { "User SpaceportDone" },
	config = function()
		local wk = require("stuff.wkutils")

		wk.makeGroup("n", "<leader>g", "[G]it", function(remap)
			remap("s", "[S]tatus", vim.cmd.Git)
			remap("P", "[P]ull", function()
				vim.cmd("Git pull")
			end)
			remap("p", "[P]ush", function()
				vim.cmd("Git push")
			end)
		end)

		wk.writeBuf()
	end,
}
