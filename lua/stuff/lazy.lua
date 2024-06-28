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
    -- install = {
    -- 	-- missing = false,
    -- },
    checker = {
        enabled = false,
        frequency = 300,
        notify = false,
    },
})
