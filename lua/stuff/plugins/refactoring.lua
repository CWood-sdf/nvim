return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("refactoring").setup({})
    end,
    init = function()
        local wk = require('stuff.wkutils')
        wk.makeGroup("x", "<leader>r", "[R]efactor", function(remap)
            remap("e", "[E]xtract", ":Refactor extract ")
            remap("f", "Extract to [f]ile", ":Refactor extract_to_file ")

            remap("v", "Extract [v]ariable", ":Refactor extract_var ")

            remap("i", "[I]nline var", ":Refactor inline_var")
        end)
        wk.makeGroup("n", "<leader>r", "[R]efactor", function(remap)
            remap("i", "[I]nline var", ":Refactor inline_var")

            remap("I", "[I]nline fn", ":Refactor inline_func")

            remap("b", "Extract [b]lock", ":Refactor extract_block")
            remap("B", "Extract [b]lock to file", ":Refactor extract_block_to_file")
        end)
        wk.writeBuf()
    end,
    cmd = "Refactor",
}
