return {
    "ThePrimeagen/harpoon",
    event = { "User SpaceportDone" },
    branch = "harpoon2",
    config = function()
        vim.opt.showtabline = 2
        local harpoon = require("harpoon")

        -- local ui = require("harpoon.ui")
        local wk = require("stuff.wkutils")
        harpoon:setup({})
        harpoon:extend(require("harpoontabline").get())

        wk.remapNoGroup("n", "<leader>a", "Toggle Harpoon", function()
            local len = harpoon:list():length()
            harpoon:list():add()
            if harpoon:list():length() == len then
                harpoon:list():remove()
            end
        end, {})
        wk.writeBuf()

        wk.remapNoGroup("n", "<C-e>", "Harpoon quick menu", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, {})
        wk.writeBuf()
        wk.remapNoGroup("n", "<leader>h", "{count}[H]arpoon nav", function()
            if vim.v.count == nil or vim.v.count == 0 then
                print("No count provided for epic harpoon nav")
            elseif vim.v.count > harpoon:list():length() then
                print("Count provided is too large for epic harpoon nav")
            else
                harpoon:list():select(vim.v.count)
            end
        end)
        wk.writeBuf()
    end,
    dependencies = {
        {
            "CWood-sdf/harpoontabline",
            dev = require("stuff.isdev")("harpoontabline"),
        },
    },
}
