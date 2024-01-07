return {
    "nvim-telescope/telescope.nvim",
    keys = "<leader>f",
    version = "0.1.3",
    opts = {},
    -- or                            , branch = '0.1.x',
    dependencies = { { "nvim-lua/plenary.nvim" } },
    init = function()
        local wk = require('stuff.wkutils')
        wk.makeGroup("n", "<leader>f", "[F]ind", function(remap)
            remap("f", "[F]iles", function()
                require("telescope.builtin").find_files()
            end)
            remap("w", "Tmux [w]indow", function()
                require("telescope").load_extension("spaceport")
                require("telescope").extensions.spaceport.tmux_windows()
            end)
            remap("p", "[p]roject", function()
                require("telescope").load_extension("spaceport")
                require("telescope").extensions.spaceport.projects()
            end)
            remap("s", "[S]tring", function()
                require("telescope.builtin").live_grep()
            end)
            remap("b", "[B]uffer", function()
                require("telescope.builtin").buffers()
            end)
            remap("h", "[H]elp", function()
                require("telescope.builtin").help_tags()
            end)
            remap("c", "[C]ommands", function()
                require("telescope.builtin").commands()
            end)
            remap("t", "[T]ags", function()
                require("telescope.builtin").tags()
            end)
            remap("r", "[R]ecent file", function()
                require("telescope.builtin").oldfiles()
            end)
            remap("g", "[G]it files (<C-p>)", function()
                require("telescope.builtin").git_files()
            end)
        end)
        wk.writeBuf()
    end,
}
