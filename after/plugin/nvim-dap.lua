local wk = require("stuff.wkutils")
local function setupDap()
    local dapui = require("dapui")
    require("mason").setup()
    require("mason-nvim-dap").setup({
        handlers = {}, -- sets up dap in the predefined manner
    })

    local dap = require('dap')
    dap.configurations.cuda = dap.configurations.cpp
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
end

local function terminateDap()
    local dapui = require("dapui")
    dapui.close()
    vim.cmd('DapTerminate')
end
local dapSetup = false
local function dapRemap(fn)
    return function()
        if not dapSetup then
            dapSetup = true
            setupDap()
        end
        fn()
    end
end
wk.makeGroup('n', '<leader>d', '[D]ebug', function(remap)
    remap('b', '[B]reakpoint', dapRemap(vim.cmd.DapToggleBreakpoint))
    remap('c', '[C]ontinue (<F5>)', dapRemap(vim.cmd.DapContinue))
    remap('i', 'Step [I]nto (<F11>)', dapRemap(vim.cmd.DapStepInto))
    remap('o', 'Step [O]ut (<F12>)', dapRemap(vim.cmd.DapStepOut))
    remap('s', '[S]tep Over (<F10>)', dapRemap(vim.cmd.DapStepOver))
    remap('t', '[T]erminate (<S-F5>)', dapRemap(terminateDap))
end)
wk.makeGroup("n", '<leader>du', '[U]i', function(remap)
    remap('t', '[T]oggle', dapRemap(function()
        local dapui = require("dapui")
        dapui.toggle();
    end))
    remap('c', '[C]lose', dapRemap(function()
        local dapui = require("dapui")
        dapui.close();
    end))
    remap('o', '[O]pen', dapRemap(function()
        local dapui = require("dapui")
        dapui.open();
    end))
end)
wk.writeBuf()
