return {
    "ThePrimeagen/harpoon",
    event = { "User SpaceportDone" },
    config = function()
        local mark = require("harpoon.mark")

        local ui = require("harpoon.ui")
        local wk = require("stuff.wkutils")

        wk.remapNoGroup("n", "<leader>a", "Toggle Harpoon", mark.toggle_file, {})
        wk.writeBuf()

        wk.remapNoGroup("n", "<C-e>", "Harpoon quick menu", ui.toggle_quick_menu)
        wk.writeBuf()
        wk.remapNoGroup("n", "<leader>h", "{count}[H]arpoon nav", function()
            if vim.v.count == nil or vim.v.count == 0 then
                print("No count provided for epic harpoon nav")
            elseif vim.v.count > mark.get_length() then
                print("Count provided is too large for epic harpoon nav")
            else
                ui.nav_file(vim.v.count)
            end
        end)
        wk.writeBuf()
        require("harpoon.tabline").setup({})
        vim.cmd("hi! link HarpoonActive TablineSel")
        vim.cmd("hi! link HarpoonNumberActive TablineSel")
        vim.cmd("hi! link HarpoonNumberInactive Tabline")
        vim.cmd("hi! link HarpoonInactive Tabline")
    end,
}
