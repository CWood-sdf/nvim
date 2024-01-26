return {
    {
        "CWood-sdf/pineapple",
        dependencies = require("stuff.pineapple"),
        config = function()
            require('pineapple').setup({
                installedRegistry = "stuff.pineapple",
                colorschemeFile = "after/plugin/theme.lua",
            })
        end,
        -- lazy = false,
        cmd = "Pineapple",
        -- priority = 1000,
        -- commit = "d2ad4b8c012eaaa37ac043d78fce2bee155efda6",
        dev = true,
    },
}
