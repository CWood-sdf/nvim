-- taken from folke's dotfiles
return {
    { "nvim-neotest/neotest-plenary", lazy = true },
    {
        "nvim-neotest/neotest",
        opts = {
            adapters = {
                ["neotest-plenary"] = {
                    min_init = "./tests/init.lua",
                },
            }
        },
        lazy = true,
    },
}
