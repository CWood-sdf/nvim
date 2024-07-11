return {
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    config = function()
        require('todo-comments').setup({
            signs = false,

        })
        local wk = require("stuff.wkutils")
        wk.useGroup("n", "]", function(remap)
            remap("T", "Next todo", function()
                require('todo-comments').jump_next()
            end)
        end)
        wk.useGroup("n", "[", function(remap)
            remap("T", "Previous todo", function()
                require('todo-comments').jump_prev()
            end)
        end)
        wk.useGroup("n", "<leader>f", function(remap)
            remap("T", "[T]odo", function()
                require("telescope").load_extension("todo-comments")
                vim.cmd("TodoTelescope")
            end)
        end)
        wk.writeBuf()
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
}
