return {
    "CWood-sdf/lazyline.nvim",
    dev = require("stuff.isdev")("lazyline.nvim"),
    -- lazy = false,
    config = function()
        require("lazyline").setup(require('stuff.lualine'))
    end,
}
