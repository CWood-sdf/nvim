require("mason").setup()
require("mason-nvim-dap").setup({
    ensure_installed = {},
    handlers = {}, -- sets up dap in the predefined manner
})

local dap = require('dap')
local dapui = require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    require('lualine').hide()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
    require('lualine').hide({
        unhide = true
    })
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
    require('lualine').hide({
        unhide = true
    })
end
dapui.setup()
