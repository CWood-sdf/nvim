vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "SpaceportDone",
	callback = function()
		local local_config = vim.fn.getcwd() .. "/conf.lua"
		if vim.fn.filereadable(local_config) == 1 then
			dofile(local_config)
		end
	end,
})
