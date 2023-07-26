local mark = require("harpoon.mark")

local ui = require("harpoon.ui")
local wk = require("stuff.wkutils")

wk.remapNoGroup('n', '<leader>a', "Toggle Harpoon", mark.toggle_file)

wk.remapNoGroup("n", "<C-e>", "Harpoon quick menu", ui.toggle_quick_menu)
wk.remapNoGroup("n", "<C-n>", "Harpoon nav file 1", function()
    ui.nav_file(1)
end)
wk.remapNoGroup("n", "<C-u>", "Harpoon nav file 2", function()
    ui.nav_file(2)
end)
wk.remapNoGroup("n", "<leader>h", "{count}[H]arpoon nav", function()
    if (vim.v.count == nil or vim.v.count == 0) then
        print("No count provided for epic harpoon nav")
    elseif (vim.v.count > mark.get_length()) then
        print("Count provided is too large for epic harpoon nav")
    else
        ui.nav_file(vim.v.count)
    end
end)
wk.writeBuf()
require('harpoon.tabline').setup({

})
