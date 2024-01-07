return {
    -- Debugger stuff
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "jay-babu/mason-nvim-dap.nvim",
            "williamboman/mason.nvim",
        },
        init = function()
            local wk = require('stuff.wkutils')
            wk.makeGroup("n", "<leader>d", "[D]ebug", function(remap)
                remap("b", "[B]reakpoint", vim.cmd.DapToggleBreakpoint)
                -- remap('i', 'Conditional bp', function()
                --     require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')
                -- end)
                remap("c", "[C]ontinue (<F5>)", vim.cmd.DapContinue)
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
                require("lualine").hide({
                    unhide = false,
                    place = { "statusline" },
                })
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
                require("lualine").hide({
                    unhide = true,
                    place = { "statusline" },
                })
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
                require("lualine").hide({
                    unhide = true,
                    place = { "statusline" },
                })
            end
            dapui.setup()
            local wk = require("stuff.wkutils")
            local function terminateDap()
                dapui.close()
                vim.cmd("DapTerminate")
            end
            wk.makeGroup("n", "<leader>d", "[D]ebug", function(remap)
                remap("i", "Step [I]nto (<F11>)", vim.cmd.DapStepInto)
                remap("o", "Step [O]ut (<F12>)", vim.cmd.DapStepOut)
                remap("s", "[S]tep Over (<F9>)", vim.cmd.DapStepOver)
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
}
