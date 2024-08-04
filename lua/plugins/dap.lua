vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "LazyLoad",
    callback = function(data)
        if data.data == "nvim-dap" then
            vim.api.nvim_exec_autocmds("User", { pattern = "LoadNvimLuaDap" })
        end
    end,
})
vim.api.nvim_create_user_command("BlockingDebugServer", function()
    require('osv').launch({ port = 8086, blocking = true })
end, {})
return {
    {
        "jbyuki/one-small-step-for-vimkind",
        requires = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            local dap = require("dap")
            dap.configurations.lua = {
                {
                    type = 'nlua',
                    request = 'attach',
                    name = "Attach to running Neovim instance",
                }
            }

            dap.adapters.nlua = function(callback, config)
                callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
            end
        end,
        event = "User LoadNvimLuaDap",

    },
    -- Debugger stuff
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "jay-babu/mason-nvim-dap.nvim",
            "williamboman/mason.nvim",
            "nvim-neotest/nvim-nio",
            -- 'theHamsta/nvim-dap-virtual-text',
        },
        init = function()
            local wk = require('stuff.wkutils')
            wk.makeGroup("n", "<leader>d", "[D]ebug", function(remap)
                remap("b", "[B]reakpoint", vim.cmd.DapToggleBreakpoint)
                remap('v', 'Ser[v]er', function()
                    require('osv').launch({ port = 8086 })
                end)
                local inst = nil
                remap('y', 'Banana debug', function()
                    if inst == nil then
                        inst = require('banana.instance').newInstance('test', '')
                    end
                    inst:open()
                    -- require('banana').spam()
                end)
                remap('Y', 'Banana debug', function()
                    local name = vim.fn.input("Path to nml: ")
                    local inst = require("banana.render").newInstance(name, "asdf")
                    inst.DEBUG = false
                    inst:open()
                    -- vim.cmd("Pineapple2")
                end)
                -- remap('i', 'Conditional bp', function()
                --     require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')
                -- end)
                remap("c", "[C]ontinue (<F5>)", function()
                    vim.cmd.DapContinue()
                end)
            end)
            wk.writeBuf()
        end,
        config = function()
            local dapui = require("dapui")
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "codelldb",
                },
                automatic_installation = false,
                handlers = {}, -- sets up dap in the predefined manner
            })

            local dap = require("dap")
            dap.configurations.cuda = dap.configurations.cpp
            dap.listeners.after.event_initialized["dapui_config"] = function()
                -- require("lualine").hide({
                --     unhide = false,
                --     place = { "statusline" },
                -- })
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
                -- require("lualine").hide({
                --     unhide = true,
                --     place = { "statusline" },
                -- })
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
                -- require("lualine").hide({
                --     unhide = true,
                --     place = { "statusline" },
                -- })
            end
            dapui.setup()
            local wk = require("stuff.wkutils")
            local function terminateDap()
                dapui.close()
                vim.cmd("DapTerminate")
                -- require("lualine").hide({
                --     unhide = true,
                --     place = { "statusline" },
                -- })
            end
            wk.makeGroup("n", "<leader>d", "[D]ebug", function(remap)
                remap("i", "Step [I]nto (<F11>)", vim.cmd.DapStepInto)
                remap("o", "Step [O]ut (<F12>)", vim.cmd.DapStepOut)
                remap("s", "[S]tep Over (<F10>)", vim.cmd.DapStepOver)
                remap("t", "[T]erminate (<S-F5>)", terminateDap)
            end)
            wk.makeGroup("n", "<leader>du", "[U]i", function(remap)
                remap("t", "[T]oggle", function()
                    dapui.toggle()
                end)
                remap("c", "[C]lose", function()
                    dapui.close()
                end)
                remap("o", "[O]pen", function()
                    dapui.open()
                end)
            end)
            wk.writeBuf()
            vim.cmd('hi! DapBreakpoint guifg=#ff0000')
            vim.cmd('hi! DapActive guifg=#eeeeee')
            -- - `DapBreakpointCondition` for conditional breakpoints (default: `C`)
            -- - `DapLogPoint` for log points (default: `L`)
            vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
            vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
            vim.fn.sign_define('DapBreakpointCondition',
                { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
            vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapActive', linehl = '', numhl = '' })
        end,
        cmd = { "DapContinue", "DapToggleBreakpoint" },
        keys = { "<leader>d" },
    },
    -- {
    --     'theHamsta/nvim-dap-virtual-text',
    --     opts = {
    --
    --     },
    --     lazy = true,
    -- }
}
