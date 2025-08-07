-- taken from folke's dotfiles
return {
    { "nvim-neotest/neotest-plenary", lazy = true },
    {
        "nvim-neotest/neotest",
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-plenary")({
                        min_init = "./tests/init.lua",
                    }),
                }
            })
        end,
        lazy = true,
    },
}
