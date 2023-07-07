local mark = require("harpoon.mark")

local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.toggle_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-n>", function()
    ui.nav_file(1)
end)
vim.keymap.set("n", "<C-u>", function()
    ui.nav_file(2)
end)
vim.keymap.set("n", "<leader>m", function()
    if (vim.v.count == nil or vim.v.count == 0) then
        print("No count provided for epic harpoon nav")
    else
        ui.nav_file(vim.v.count)
    end
end)
