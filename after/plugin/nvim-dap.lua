local wk = require("stuff.wkutils")
require("mason").setup()
require("mason-nvim-dap").setup({
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
local function terminateDap()
    dapui.close()
    vim.cmd('DapTerminate')
end
dapui.setup()
wk.makeGroup('n', '<leader>d', '[D]ebug', function(remap)
    remap('b', '[B]reakpoint', vim.cmd.DapToggleBreakpoint)
    remap('c', '[C]ontinue (<F5>)', vim.cmd.DapContinue)
    remap('i', 'Step [I]nto (<F11>)', vim.cmd.DapStepInto)
    remap('o', 'Step [O]ut (<F12>)', vim.cmd.DapStepOut)
    remap('s', '[S]tep Over (<F10>)', vim.cmd.DapStepOver)
    remap('t', '[T]erminate (<S-F5>)', terminateDap)
end)
wk.makeGroup("n", '<leader>du', '[U]i', function(remap)
    remap('t', '[T]oggle', dapui.toggle)
    remap('c', '[C]lose', dapui.close)
    remap('o', '[O]pen', dapui.open)
end)
wk.writeBuf()
