vim.g.mapleader = " "
require("stuff.lazy")
require("stuff.config").setup()
require("stuff.remap")
require("stuff.set")
require("stuff.session")
vim.lsp.enable("z2ls", false)
-- vim.lsp.enable("lua_ls", false)
