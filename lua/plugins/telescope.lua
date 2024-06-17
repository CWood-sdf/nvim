return {
    {
        "nvim-telescope/telescope.nvim",
        keys = "<leader>f",
        version = "0.1.3",
        opts = {},
        -- or                            , branch = '0.1.x',
        dependencies = { { "nvim-lua/plenary.nvim" } },
        init = function()
            local wk = require('stuff.wkutils')
            local nerdyLoaded = false
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
                remap("P", "New [P]roject", function()
                    require("telescope").load_extension("spaceport")
                    require("telescope").extensions.spaceport.find()
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
                remap('e', 'Th[e]me', function()
                    vim.cmd("Lazy! load pineapple")
                    require("telescope").load_extension("pineapple")
                    require("telescope").extensions.pineapple.colorschemes()
                end)
                remap("N", "[N]erd fonts", function()
                    if not nerdyLoaded then
                        require("telescope").load_extension("nerdy")
                        nerdyLoaded = true
                    end
                    vim.cmd("Telescope nerdy")
                end)
            end)
            wk.writeBuf()
        end,
    },
    {
        '2KAbhishek/nerdy.nvim',
        cmd = "Nerdy",
        keys = "<leader>fN",
        depends = { "nvim-telescope/telescope.nvim" },
    },

}
