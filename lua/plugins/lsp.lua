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
            wk.remapNoGroup("n", "<leader>vt", "[T]oggle trouble", function()
                vim.cmd("TroubleToggle")
            end)
            wk.writeBuf()

            local configs = require('lspconfig.configs')
            if not configs.maple then
                configs.maple = {
                    default_config = {
                        cmd = { os.getenv("HOME") .. "/projects/Maple/lsp/target/debug/maple-lsp" },
                        filetypes = { "maple", "mpl" },
                        root_dir = function()
                            return vim.fn.getcwd()
                        end,
                    },
                }
            end
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
                        vim.lsp.inlay_hint.enable(nil)
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
                    remap("S", "[S]top", function()
                        vim.cmd("LspStop")
                    end, opts)
                    remap("R", "[R]estart", function()
                        vim.cmd("LspRestart")
                    end, opts)
                end, opts)
                wk.makeGroup("n", "<leader>vo", "G[o]to", function(remap)
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
                    if server_name == "arduino_language_server" then
                        return
                    end
                    if server_name == "html" then
                        return
                    end
                    -- local f = io.open("skip.sdf", "r")
                    -- if f ~= nil and server_name == "clangd" then
                    --     f:close()
                    --     return
                    -- end
                    require('lspconfig')[server_name].setup({
                        -- if server_name == "arduino
                        on_attach = onAttach,
                    })
                end,
            })
            require('lspconfig').maple.setup({
                on_attach = onAttach,
            })
            require('lspconfig').gleam.setup({
                on_attach = onAttach,
            })
            -- require('lspconfig').glint.setup({
            --     on_attach = onAttach,
            -- })
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            require('lspconfig').html.setup({
                on_attach = onAttach,
                filetypes = { "html", "templ", "handlebars" },
                capabilities = capabilities,
            })
            require('lspconfig').tailwindcss.setup({
                on_attach = onAttach,
                filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "handlebars" },
                capabilities = capabilities,
            })
            require('lspconfig').htmx.setup({
                on_attach = onAttach,
                filetypes = { "html", "javascriptreact", "templ", "typescriptreact", "handlebars" },
                capabilities = capabilities,
            })
            -- require('lspconfig').ccls.setup({})
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
            require("lspconfig").arduino_language_server.setup({
                on_attach = onAttach,
                cmd = {
                    os.getenv("HOME") .. "/.local/share/nvim/mason/bin/arduino-language-server",
                    -- "-clangd",
                    -- os.getenv("HOME") .. "/.local/share/nvim/mason/bin/clangd",
                    -- "-fqbn",
                    -- "arduino:avr:uno",
                    "-cli-config",
                    os.getenv("HOME") .. "/snap/arduino-cli/45/.arduino15/arduino-cli.yaml",
                    "-log",
                    "true",
                },
            })
            vim.diagnostic.config({
                virtual_text = true,
            })

            vim.fn.sign_define("DiagnosticSignError", {
                text = "",
                texthl = "DiagnosticError",
            })
            vim.fn.sign_define("DiagnosticSignWarn", {
                text = "",
                texthl = "DiagnosticWarn",
            })
            vim.fn.sign_define("DiagnosticSignInfo", {
                text = "",
                texthl = "DiagnosticInfo",
            })
            vim.fn.sign_define("DiagnosticSignHint", {
                text = "",
                texthl = "DiagnosticHint",
            })
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
    {
        "laytan/cloak.nvim",
        opts = {},
        event = "BufReadPre",
    },
}
