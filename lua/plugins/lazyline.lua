return {
    "CWood-sdf/lazyline.nvim",
    dev = true,
    -- lazy = false,
    config = function()
        require("lazyline").setup(require('stuff.lualine'))
    end,
}
