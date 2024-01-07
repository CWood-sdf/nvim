return {
    --trouble
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        -- "VonHeikemen/lsp-zero.nvim",
        -- branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { "williamboman/mason-lspconfig.nvim" }, -- Optional
            { "williamboman/mason.nvim" },           -- Optional
            -- {
            --     "kosayoda/nvim-lightbulb",
            --     opts = { autocmd = { enabled = true } }
            -- },

            -- Autocompletion
            -- { "folke/neodev.nvim" },
        },
        event = "BufReadPre *.*",
        config = function()
            local wk = require("stuff.wkutils")

            ---@diagnostic disable-next-line: unused-local
            local onAttach = function(args, bufnr)
                local opts = { buffer = bufnr, noremap = false }
                wk.remapNoGroup("n", "K", "Hover", function()
                    vim.lsp.buf.hover()
                end, opts)
                wk.makeGroup("n", "<leader>v", "LSP", function(remap)
                    remap("d", "[D]iagnostic float", function()
                        vim.diagnostic.open_float()
                    end, opts)
                    remap("i", "[I]nlay hints", function()
                        vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
                    end, opts)
                    remap("h", "[H]over (K)", function()
                        vim.lsp.buf.hover()
                    end, opts)
                    remap("a", "[A]ction", function()
                        vim.lsp.buf.code_action()
                    end, opts)
                    remap("n", "[N]ext diagnostic (]d)", function()
                        vim.diagnostic.goto_next()
                    end, opts)
                    remap("p", "[P]revious diagnostic ([d)", function()
                        vim.diagnostic.goto_prev()
                    end, opts)
                    remap("s", "[S]ignature help (<C-h>)", function()
                        vim.lsp.buf.signature_help()
                    end, opts)
                    remap("r", "[R]ename", function()
                        vim.lsp.buf.rename()
                    end, opts)
                    remap("t", "[T]oggle trouble", function()
                        vim.cmd("TroubleToggle")
                    end, opts)
                end, opts)
                wk.makeGroup("n", "<leader>vg", "Goto", function(remap)
                    remap("d", "[D]efinition (gd)", function()
                        vim.lsp.buf.definition()
                    end, opts)
                    remap("i", "[I]mplementation (gI)", function()
                        vim.lsp.buf.implementation()
                    end, opts)
                    remap("t", "[T]ype definition (gy)", function()
                        vim.lsp.buf.type_definition()
                    end, opts)
                    remap("D", "[D]eclaration (gD)", function()
                        vim.lsp.buf.declaration()
                    end, opts)
                    remap("r", "[R]eferences (gr)", function()
                        vim.lsp.buf.references()
                    end, opts)
                end, opts)
                wk.makeGroup("n", "<leader>vw", "Workspace", function(remap)
                    remap("s", "[S]ymbols", function()
                        vim.lsp.buf.workspace_symbol()
                    end, opts)
                end, opts)
                wk.writeBuf()
            end
            require('mason').setup({
                ensure_installed = {
                    "clangd",
                    "lua-language-server",
                    "rust-analyzer",
                },
            });
            require('mason-lspconfig').setup({
                automatic_installation = true,
            });
            require('mason-lspconfig').setup_handlers({
                function(server_name)
                    if server_name == "lua_ls" then
                        return
                    end
                    require('lspconfig')[server_name].setup({
                        -- if server_name == "arduino
                        on_attach = onAttach,
                    })
                end,
            })
            require("neodev").setup({})
            require("lspconfig").lua_ls.setup({
                on_attach = onAttach,
                settings = {
                    Lua = {
                        hint = {
                            enable = true,
                        },
                    },
                },
            })
            vim.diagnostic.config({
                virtual_text = true,
            })

            vim.fn.sign_define("DiagnosticSignError", {
                text = "",
                texthl = "TextError",
            })
            vim.fn.sign_define("DiagnosticSignWarn", {
                text = "",
                texthl = "TextWarn",
            })
            vim.fn.sign_define("DiagnosticSignInfo", {
                text = "",
                texthl = "TextInfo",
            })
            vim.fn.sign_define("DiagnosticSignHint", {
                text = "",
                texthl = "TextHint",
            })


            local id = nil
            wk.useGroup("n", "<leader>v", function(remap)
                remap("L", "LSP restart", function()
                    if id ~= nil then
                        vim.lsp.stop_client(id)
                        id = nil
                    end
                    ---@diagnostic disable-next-line: missing-fields
                    id = vim.lsp.start_client({
                        filetypes = { "maple", "mpl" },
                        name = "maple",
                        cmd = { "/home/cwood/projects/maple/lsp/target/debug/maple-lsp" },
                        ---@diagnostic disable-next-line: assign-type-mismatch
                        root_dir = vim.fs.dirname(vim.fs.find({ "maple.mpl" }, { upward = true })[1]),
                        ---@diagnostic disable-next-line: assign-type-mismatch
                        cmd_cwd = vim.fn.getcwd(),
                    })
                    local bufnr = vim.api.nvim_get_current_buf()
                    if vim.lsp.buf_is_attached(bufnr, id or -1) then
                        return
                    end
                    print("Attaching maple lsp")
                    local ok = vim.lsp.buf_attach_client(bufnr, id or -1)
                    if not ok then
                        print("Failed to attach maple lsp")
                    end
                end)
                remap("D", "LSP stop", function()
                    if id ~= nil then
                        local bufnr = vim.api.nvim_get_current_buf()
                        vim.lsp.buf_detach_client(bufnr, id)
                        vim.lsp.stop_client(id)
                    else
                        print("LSP not running")
                    end
                end)
            end)
        end,
    },
    {
        "folke/neodev.nvim",
        event = "BufReadPre *.lua",
        opts = {},
    },
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {
            -- options
            window = {
                blend = 0,
            },
        },
    },
}
