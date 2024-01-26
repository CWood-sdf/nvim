return {
    "CWood-sdf/spaceport.nvim",
    opts = {
        replaceDirs = { { "~/projects", "_" }, { "/mnt/c/Users/woodc", "$" }, { "~/.local/share/nvim", "@" } },
        replaceHome = true,
        projectEntry = function()
            vim.cmd("Oil")
            vim.cmd("e")
        end,
        -- lastViewTime = "yesterday",
        maxRecentFiles = 25,
        sections = {
            "_global_remaps",
            "name_blue_green",
            "remaps",
            "recents",
            "hacker_news",
        },
        debug = false,
    },
    dev = true,
    -- priority = 1000,
}
