return {
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre *.*",
        config = function()
            -- require("colorizer").setup()
            require("colorizer").setup({
                "*",
                nml = {
                    rgb_fn = true,
                },
                ncss = {
                    rgb_fn = true,
                },
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
