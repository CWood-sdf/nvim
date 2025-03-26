return {
    "CWood-sdf/spaceport.nvim",
    opts = {
        replaceDirs = { { "~/projects", "_" }, { "~/.local/share/nvim", "@" }, { "~/Documents/clubs", "C" } },
        replaceHome = true,
        icons = false,
        projectEntry = function()
            vim.cmd("SessionSource")
            -- vim.schedule(function()
            --     vim.cmd("e")
            -- end)
        end,
        maxRecentFiles = 18,
        sections = {
            "_global_remaps",
            { "name", config = { style = "lite", gradient = "blue_green" } },
            "remaps",
            "recents",
            "hacker_news",
        },
        shortcuts = {
            { "f", ".config/nvim" },
            { "r", "sac_24%-25" },
            { "i", "pineapple" },
            { "s", "spaceport.nvim" },
            { "c", "calendar" },
            { "b", "banana.nvim" },
            { "m", "cmdTree" },
            { "H", "hw" },
            { "e", "irec.*groundstation" },
            -- { "t", "thing" },
            -- { "a", "lazyline.nvim" },
            { "o", "notes" },
        },
        debug = true,
    },
    dev = require("stuff.isdev")("spaceport.nvim"),
}
