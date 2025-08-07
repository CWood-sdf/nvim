vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local wk = require('stuff.wkutils')
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
            remap("h", "[H]over", function()
                vim.lsp.buf.hover()
            end, opts)
            remap("a", "[A]ction", function()
                vim.lsp.buf.code_action()
            end, opts)
            remap("E", "Prev [E]rror ([e)", function()
                vim.diagnostic.jump({
                    count = -1,
                    severity = vim.diagnostic.severity.ERROR
                })
            end, opts)
            remap("e", "Next [e]rror (]e)", function()
                vim.diagnostic.jump({
                    count = 1,
                    severity = vim.diagnostic.severity.ERROR
                })
            end, opts)
            remap("n", "[N]ext diagnostic", function()
                vim.diagnostic.jump({
                    count = 1,
                })
            end, opts)
            remap("p", "[P]revious diagnostic", function()
                vim.diagnostic.jump({
                    count = -1,
                })
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
            remap("r", "[R]eferences", function()
                vim.lsp.buf.references()
            end, opts)
        end, opts)
        wk.makeGroup("n", "<leader>vw", "Workspace", function(remap)
            remap("s", "[S]ymbols", function()
                vim.lsp.buf.workspace_symbol()
            end, opts)
        end, opts)
        wk.writeBuf()
    end,
})
return {

    -- {
    --     "pmizio/typescript-tools.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    --     opts = {
    --         settings = {
    --             code_lens = "none",
    --             disable_member_code_lens = false,
    --             hover = true,
    --         },
    --     },
    --     ft = { "javascript", "typescript" },
    -- },
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
            {
                "williamboman/mason-lspconfig.nvim",
                branch = "perf/cached-specs",
                opts = {
                },
                -- dev = true,
            }, -- Optional
            -- { "williamboman/mason.nvim" }, -- Optional
            -- {
            --     "kosayoda/nvim-lightbulb",
            --     opts = { autocmd = { enabled = true } }
            -- },

            -- Autocompletion
            -- { "folke/neodev.nvim" },
        },
        event = "BufReadPre",
        config = function()
            local wk = require("stuff.wkutils")
            wk.remapNoGroup("n", "<leader>vt", "[T]oggle trouble", function()
                vim.cmd("TroubleToggle")
            end)
            wk.writeBuf()

            -- local configs = require('lspconfig.configs')
            -- if not configs.maple then
            --     configs.maple = {
            --         default_config = {
            --             cmd = { os.getenv("HOME") .. "/projects/Maple/lsp/target/debug/maple-lsp" },
            --             filetypes = { "maple", "mpl" },
            --             root_dir = function()
            --                 return vim.fn.getcwd()
            --             end,
            --         },
            --     }
            -- end
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
            capabilities.textDocument.completion.completionItem.snippetSupport = true


            ---@diagnostic disable-next-line: unused-local
            -- local onAttach = function(args, bufnr)
            -- end
            -- require("lspconfig").lua_ls.setup({
            --     settings = {
            --         Lua = {
            --             completion = {
            --                 callSnippet = 'Enable',
            --                 keywordSnippet = 'Enable',
            --             },
            --         },
            --     },
            --     capabilities = capabilities
            -- })
            -- require('lspconfig')["pylsp"].setup({
            --     -- if server_name == "arduino
            --     on_attach = onAttach,
            --     settings = {
            --         pylsp = {
            --             plugins = {
            --                 flake8 = {
            --                     enabled = false,
            --                     ignore = { 'E501', 'E231' },
            --                     maxLineLength = 88,
            --                 },
            --                 black = { enabled = true },
            --                 autopep8 = { enabled = false },
            --                 mccabe = { enabled = false },
            --                 pycodestyle = {
            --                     enabled = false,
            --                     ignore = { 'E501', 'E231' },
            --                     maxLineLength = 88,
            --                 },
            --                 pyflakes = { enabled = false },
            --             }
            --         }
            --     },
            -- })
            -- require('lspconfig').maple.setup({
            --     on_attach = onAttach,
            -- })
            -- require('lspconfig').gleam.setup({
            --     on_attach = onAttach,
            -- })
            -- require('lspconfig').glint.setup({
            --     on_attach = onAttach,
            -- })
            -- ArId = vim.lsp.start_client({
            --     on_attach = onAttach,
            --     capabilities = capabilities,
            --     filetypes = { "ino", "arduino" },
            --     root_dir = "/home/christopher-wood/projects/EgrThingThing",
            --     cmd_cwd = "/home/christopher-wood/projects/EgrThingThing",
            --     name = "arduino-language-server",
            --     cmd = {
            --         os.getenv("HOME") .. "/.local/share/nvim/mason/bin/arduino-language-server",
            --         -- "-clangd",
            --         -- os.getenv("HOME") .. "/.local/share/nvim/mason/bin/clangd",
            --         "-fqbn",
            --         "arduino:avr:uno",
            --         "-cli-config",
            --         os.getenv("HOME") .. "/snap/arduino-cli/45/.arduino15/arduino-cli.yaml",
            --         "-log",
            --         "true",
            --     },
            -- })
            -- require('lspconfig').html.setup({
            --     on_attach = onAttach,
            --     filetypes = { "html", "nml", "templ" },
            --     capabilities = capabilities,
            -- })
            -- require('lspconfig').tailwindcss.setup({
            --     on_attach = onAttach,
            --     filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "handlebars" },
            --     capabilities = capabilities,
            -- })
            -- require('lspconfig').htmx.setup({
            --     on_attach = onAttach,
            --     filetypes = { "html", "javascriptreact", "templ", "typescriptreact", "handlebars" },
            --     capabilities = capabilities,
            -- })
            -- require('lspconfig').ccls.setup({})
            -- require("lspconfig").lua_ls.setup({
            --     on_attach = onAttach,
            --     cmd = { "/home/christopher-wood/projects/lua-language-server/bin/lua-language-server" },
            --     settings = {
            --         Lua = {
            --             misc = {
            --                 parameters = {
            --                     "--dbgport=11428", "--develop=true", "--dbgwait=true"
            --                 }
            --             },
            --             hint = {
            --                 enable = true,
            --             },
            --         },
            --     },
            -- })
            vim.diagnostic.config({
                virtual_text = true,
                severity_sort = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.HINT] = "",
                    }
                },
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
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "clangd",
                "lua-language-server",
                "rust-analyzer",
            },
        },
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
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                "luvit-meta/library", -- see below
                -- You can also add plugins you always want to have loaded.
                -- Useful if the plugin has globals or types you want to use
                -- vim.env.LAZY .. "/LazyVim", -- see below
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}
