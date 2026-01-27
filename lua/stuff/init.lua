vim.g.mapleader = " "
require("stuff.lazy")
require("stuff.zine")
require("stuff.config").setup()
require("stuff.remap")
require("stuff.set")
require("stuff.session")
-- vim.lsp.enable("clangd2", true)
-- vim.lsp.enable("clangd", false)
-- vim.lsp.enable("z2ls", false)
-- vim.lsp.enable("lua_ls", true)
--
-- require("stuff.zig")
