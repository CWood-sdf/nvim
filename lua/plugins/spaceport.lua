return {
    "CWood-sdf/spaceport.nvim",
    opts = {
        replaceDirs = { { "~/projects", "_" }, { "~/.local/share/nvim", "@" } },
        replaceHome = true,
        projectEntry = function()
            -- vim.cmd("Oil .")
            -- vim.schedule(function()
            --     vim.cmd("e")
            -- end)
        end,
        maxRecentFiles = 18,
        sections = {
            "_global_remaps",
            "name_blue_green",
            "remaps",
            "recents",
            "hacker_news",
        },
        shortcuts = {
            { "f", ".config/nvim" },
            { "i", "pineapple" },
            { "s", "spaceport.nvim" },
            { "c", "calendar" },
            { "b", "banana.nvim" },
            { "w", "calendarwebthing" },
            { "m", "cmdTree" },
            { "a", "lazyline.nvim" },
        },
        debug = true,
    },
    dev = true,
}
