return {
    "mbbill/undotree",
    cmd = { "UndotreeToggle", "UndotreeShow" },
    init = function()
        vim.g.undotree_DiffAutoOpen = 0
        -- local wk = require("stuff.wkutils")
        vim.keymap.set("n", "<leader>u", function()
            vim.cmd.UndotreeToggle()
        end, { desc = "Toggle Undotree", })
        local undo = function(count)
            if count == nil then
                count = 1
            end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(count .. "u", true, true, true), "n", false)
        end
        vim.keymap.set("n", "<C-z>", function()

        end, { desc = "Undo", })
        vim.keymap.set("v", "<C-z>", function()
            local wk = require("stuff.wkutils")
            wk.feedKeys("<Esc>", "v")
            undo(vim.v.count)
        end, { desc = "Undo", })


        vim.keymap.set("i", "<C-z>", function()
            vim.cmd("stopinsert")
            undo(1)
        end, { desc = "Undo", })
    end
}
