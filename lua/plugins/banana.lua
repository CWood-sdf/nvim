return {
    {
        "CWood-sdf/banana.nvim",
        dev = require("stuff.isdev")("banana.nvim"),
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
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
