return {
    -- Lazy
    -- {
    --     "vague2k/huez.nvim",
    --     -- if you want registry related features, uncomment this
    --     -- import = "huez-manager.import"
    --     branch = "stable",
    --     event = "UIEnter",
    --     config = function()
    --         require("huez").setup({})
    --     end,
    -- },
    {
        "CWood-sdf/pineapple",
        dependencies = require("stuff.pineapple"),
        opts = {
            installedRegistry = "stuff.pineapple",
            colorschemeFile = "after/plugin/theme.lua",
        },
        -- lazy = false,
        cmd = { "Pineapple", "Pineapple2" },
        -- priority = 1000,
        -- commit = "d2ad4b8c012eaaa37ac043d78fce2bee155efda6",
        dev = require("stuff.isdev")("pineapple"),
    },
}
