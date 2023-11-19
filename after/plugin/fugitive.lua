local wk = require("stuff.wkutils")

wk.makeGroup("n", "<leader>g", "[G]it", function(remap)
	remap("s", "[S]tatus", vim.cmd.Git)
	remap("p", "[P]ush", function()
		vim.cmd("Git push")
	end)
	remap("P", "[P]ull", function()
		vim.cmd("Git pull")
	end)
end)

wk.writeBuf()
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "fugitive://*",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local opts = {
			buffer = buf,
		}
		wk.makeGroup("n", "<leader>g", "[G]it", function(remap)
			remap("a", "[A]dd all", function()
				vim.cmd("Git add .")
			end, opts)
		end, opts)

		wk.writeBuf()
	end,
})
