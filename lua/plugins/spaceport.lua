-- vim.api.nvim_set_hl(0, "Sdf", { bg = "#000000", fg = "#00ff00" })
-- vim.api.nvim_set_hl(0, "SpaceportRecentsProject", { bg = "#000000", fg = "#ab7299" })
return {
    "CWood-sdf/spaceport.nvim",
    opts = {
        replaceDirs = { { "~/projects", "_" }, { "~/.local/share/nvim", "@" } },
        replaceHome = true,
        projectEntry = function()
            vim.cmd("Oil .")
            vim.schedule(function()
                vim.cmd("e")
            end)
        end,
        -- lastViewTime = "yesterday",
        maxRecentFiles = 18,
        sections = {
            "_global_remaps",
            "name_blue_green",
            "remaps",
            "recents",
            "hacker_news",
        },
        debug = true,
    },
    dev = true,
    -- priority = 1000,
}
