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
    change_detection = {
        notify = false,
    },
    -- install = {
    -- 	-- missing = false,
    -- },
    checker = {
        enabled = true,
        frequency = 300,
        notify = false,
    },
})
