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
            dap.adapters["local-lua"] = {
                type = "executable",
                command = "node",
                args = {
                    "/home/christopher-wood/fun/local-lua-debugger-vscode/extension/debugAdapter.js"
                },
                enrich_config = function(config, on_config)
                    if not config["extensionPath"] then
                        local c = vim.deepcopy(config)
                        -- 💀 If this is missing or wrong you'll see
                        -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
                        c.extensionPath = "/home/christopher-wood/fun/local-lua-debugger-vscode/"
                        on_config(c)
                    else
                        on_config(config)
                    end
                end,
            }
            dap.configurations.lua = {
                {
                    type = 'nlua',
                    request = 'attach',
                    name = "Attach to running Neovim instance",
                },
                -- {
                --     type = "local-lua",
                --     request = "attach",
                --     port = 11428,
                --     name = "Attach to local lua",
                -- }
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
                    require('banana').test.grid()
                    -- require('banana').spam()
                end)
                remap('Y', 'Banana debug', function()
                    local name = vim.fn.input("Path to nml: ")
                    local inst = require("banana.instance").newInstance(name, "asdf")
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
                handlers = {},
            })

            local dap = require("dap")
            dap.configurations.zig = {
                {
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtBeginningOfMainSubprogram = false,
                },
                {
                    name = "Select and attach to process",
                    type = "gdb",
                    request = "attach",
                    -- program = function()
                    --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    -- end,
                    pid = function()
                        local name = vim.fn.input('Executable name (filter): ')
                        return require("dap.utils").pick_process({ filter = name })
                    end,
                    -- cwd = '${workspaceFolder}'
                },
                {
                    name = 'Attach to gdbserver :1234',
                    type = 'gdb',
                    request = 'attach',
                    target = 'localhost:1234',
                    program = function()
                        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    end,
                    cwd = '${workspaceFolder}'
                },
                unpack(dap.configurations.rust or dap.configurations.zig or dap.configurations.c or
                    dap.configurations.cpp or {}),
            }
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
            }
            dap.configurations.c = dap.configurations.zig
            dap.configurations.asm = dap.configurations.zig
            dap.configurations.cpp = dap.configurations.zig
            dap.configurations.cuda = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.c
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
