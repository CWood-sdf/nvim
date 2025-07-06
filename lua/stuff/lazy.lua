-- This file can be loaded by calling `lua require('plugins')` from your init.vim
return require("lazy").setup("plugins", {
    dev = {
        path = (function()
            if jit.os == "Windows" then
                return "C:\\Users\\woodc\\"
            end
            return "~/projects/"
        end)(),
    },
    rocks = {
        root = "/usr/local/bin",
    },
    ui = {
        backdrop = 60,
    },
    change_detection = {
        notify = false,
    },
    concurrency = 10,
    -- install = {
    -- 	-- missing = false,
    -- },
    checker = {
        concurrency = 10,
        enabled = false,
        frequency = 300,
        notify = false,
    },
})
