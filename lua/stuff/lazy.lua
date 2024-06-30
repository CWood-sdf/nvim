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
        enabled = true,
        frequency = 300,
        notify = false,
    },
})
