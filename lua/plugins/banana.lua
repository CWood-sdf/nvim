return {
    {
        "CWood-sdf/banana.nvim",
        dev = require("stuff.isdev")("banana.nvim"),
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            setupTs = true,
        },
        lazy = true,
        -- build = "bash ./build"
    },
    {
        "CWood-sdf/banana-example",
        dev = false,
        dependencies = { "CWood-sdf/banana.nvim" },
        opts = {},
        cmd = "InstallThings",
    }
    -- enabled = false,
}
