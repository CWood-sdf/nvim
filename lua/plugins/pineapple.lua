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

    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = {
            on_highlights = function(colors)
                -- vim.notify(vim.inspect(colors))
                colors.LineNr.fg = require("tokyonight.util").lighten(colors.LineNr.fg, 0.6)
                colors.LineNrAbove.fg = require("tokyonight.util").lighten(colors.LineNrAbove.fg, 0.6)
                colors.LineNrBelow.fg = require("tokyonight.util").lighten(colors.LineNrBelow.fg, 0.6)
                colors.CursorLineNr.fg = require("tokyonight.util").lighten(colors.CursorLineNr.fg, 0.6)
            end,
        }
    },
}
