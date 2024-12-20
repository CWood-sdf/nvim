return {
    {
        "CWood-sdf/banana.nvim",
        dev = require("stuff.isdev")("banana.nvim"),
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        lazy = true,
        config = function()
            require('banana').initTsParsers()
        end,
        -- build = "bash ./build"
    },
    {
        "CWood-sdf/banana-example",
        dev = false,
        dependencies = { "CWood-sdf/banana.nvim" },
        opts = {}
    }
    -- enabled = false,
}
