return {
    "cshuaimin/ssr.nvim",
    keys = "<leader>s",
    init = function()
        local wk = require('stuff.wkutils')
        wk.makeGroup({ "n", "x" }, "<leader>s", "[S]SR", function(remap)
            remap("r", "[R]un", function()
                require("ssr").open()
            end)
        end)
        wk.writeBuf()
    end,
    config = function()
        require("ssr").setup({})
    end,
}
