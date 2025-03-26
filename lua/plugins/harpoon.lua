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

        wk.makeGroup("n", "<leader>h", "Harpoon", function(remap)
            remap("o", "Open", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)
            remap("n", "1 (<C-n>)", function()
                harpoon:list():select(1)
            end)
            remap("e", "2 (<C-e>)", function()
                harpoon:list():select(2)
            end, {})
            remap("p", "3 (<C-p>)", function()
                harpoon:list():select(3)
            end, {})
            remap("y", "4 (<C-y>)", function()
                harpoon:list():select(4)
            end, {})
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
