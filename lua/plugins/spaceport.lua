return {
    "CWood-sdf/spaceport.nvim",
    config = function()
        local opts = {
            replaceDirs = { { "~/projects", "_" }, { "/mnt/c/Users/woodc", "$" }, { "~/.local/share/nvim", "@" } },
            replaceHome = true,
            projectEntry = function()
                vim.cmd("Oil")
                vim.cmd("e")
            end,
            lastViewTime = "yesterday",
            sections = {
                "_global_remaps",
                "name_blue_green",
                "remaps",
                "recents",
                "hacker_news",
            },
        }
        require("spaceport").setup(opts)
    end,
    dev = true,
    -- priority = 1000,
}
