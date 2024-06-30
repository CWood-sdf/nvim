local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.loop.fs_stat(lazypath) then
-- 	vim.fn.system({
-- 		"git",
-- 		"clone",
-- 		"--filter=blob:none",
-- 		"https://github.com/folke/lazy.nvim.git",
-- 		lazypath,
-- 	})
-- end
vim.opt.rtp:prepend(lazypath)
-- vim.opt.rtp:prepend(os.getenv("HOME") .. "/projects/banana.nvim")

vim.filetype.add({
	extension = { mpl = "maple" },
})

vim.filetype.add({
	extension = {
		nml = "nml",
	},
})
vim.filetype.add({
	extension = {
		ncss = "ncss",
	},
})

require("stuff")
