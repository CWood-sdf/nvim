vim.opt.nu = true
vim.opt.relativenumber = true

vim.cmd("set conceallevel=0")

vim.opt.smartcase = true
vim.opt.ignorecase = true
-- vim.opt.autoindent = true
-- vim.api.nvim_create_autocmd("InsertEnter", {
--     callback = function()
--         vim.opt.autoindent = false
--     end
-- })
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.signcolumn = "yes"

vim.opt.sessionoptions:append("globals")

-- vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
if jit.os == "Windows" then
    vim.opt.undodir = os.getenv("USERPROFILE") .. "\\.vim\\undodir"
else
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

local conf = require("stuff.config")
vim.opt.colorcolumn = ""
conf.addFlag("values.nocolorcolumn")
conf.addCallback("values.nocolorcolumn", function(v)
    if v then
        vim.opt.colorcolumn = ""
    else
        vim.opt.colorcolumn = "80"
    end
end)

local mouse = vim.opt.mouse
vim.opt.mouse = ""
conf.addFlag("values.nomouse")
conf.addCallback("values.nomouse", function(v)
    if not v then
        vim.opt.mouse = mouse
    else
        vim.opt.mouse = ""
    end
end)
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
