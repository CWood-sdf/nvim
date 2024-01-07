return {
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre *.*",
        config = function()
            require("colorizer").setup()
            require("colorizer").setup({
                "*",
                markdown = { names = false },
            })
        end,
    },
    {
        "ziontee113/color-picker.nvim",
        opts = {},
        cmd = { "PickColor", "PickColorInsert" },
    },
}
