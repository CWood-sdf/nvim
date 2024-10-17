return {
    "folke/which-key.nvim",
    config = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 200
        require("which-key").setup({})
    end,
    lazy = false,
}
