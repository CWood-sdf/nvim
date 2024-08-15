return {
    {
        "CWood-sdf/banana.nvim",
        dev = require("stuff.isdev")("banana.nvim"),
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        }
    },
    {
        "CWood-sdf/banana-example",
        dev = true,
        dependencies = { "CWood-sdf/banana.nvim" },
        opts = {}
    }
    -- enabled = false,
}
