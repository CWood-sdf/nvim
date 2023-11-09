require("future").load("lsp", function()
    vim.cmd("Lazy! load lsp-zero.nvim")
    vim.cmd("Lazy! load neodev.nvim")
    vim.cmd("Lazy! load mason.nvim")
    local lsp = require("lsp-zero")
    require("mason").setup()
    local wk = require("stuff.wkutils")
    lsp.preset("recommended")
    require('neodev').setup()

    -- lsp.ensure_installed({
    --     'rust_analyzer',
    --     'clangd',
    --     'lua_ls',
    -- })

    -- Fix Undefined global 'vim'
    -- lsp.nvim_workspe()


    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
        ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.confirm({ select = true }),
    }) or {}

    cmp_mappings['<Tab>'] = nil
    cmp_mappings['<S-Tab>'] = nil
    local cmp_action = require('lsp-zero').cmp_action()

    cmp_mappings['<C-d>'] = cmp_action.luasnip_jump_forward()

    cmp.setup({
        revision = 1,
        preselect = 'None',
        enabled = true,
        sources = {
            { name = "nvim_lsp" },
        },
        mapping = cmp_mappings,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
    })

    -- lsp.setup_nvim_cmp({
    --     mapping = cmp_mappings
    -- })


    lsp.set_preferences({
        suggest_lsp_servers = true,
        sign_icons = {
            error = 'E',
            warn = 'W',
            hint = 'H',
            info = 'I'
        },
    })

    local onAttach = function(_, bufnr)
        local opts = { buffer = bufnr, noremap = false }
        wk.remapNoGroup("n", "K", "Hover", function() vim.lsp.buf.hover() end, opts)
        wk.makeGroup("n", "<leader>v", "LSP", function(remap)
            remap("d", "[D]iagnostic float", function() vim.diagnostic.open_float() end, opts)
            remap("h", "[H]over (K)", function() vim.lsp.buf.hover() end, opts)
            remap("a", "[A]ction", function() vim.lsp.buf.code_action() end, opts)
            remap("n", "[N]ext diagnostic (]d)", function() vim.diagnostic.goto_next() end, opts)
            remap("p", "[P]revious diagnostic ([d)", function() vim.diagnostic.goto_prev() end, opts)
            remap("s", "[S]ignature help (<C-h>)", function() vim.lsp.buf.signature_help() end, opts)
            remap("r", "[R]ename", function() vim.lsp.buf.rename() end, opts)
        end, opts)
        wk.makeGroup("n", '<leader>vg', "Goto", function(remap)
            remap("d", "[D]efinition (gd)", function() vim.lsp.buf.definition() end, opts)
            remap("i", "[I]mplementation (gI)", function() vim.lsp.buf.implementation() end, opts)
            remap("t", "[T]ype definition (gy)", function() vim.lsp.buf.type_definition() end, opts)
            remap("D", "[D]eclaration (gD)", function() vim.lsp.buf.declaration() end, opts)
            remap("r", "[R]eferences (gr)", function() vim.lsp.buf.references() end, opts)
        end, opts)
        wk.makeGroup("n", "<leader>vw", "Workspace", function(remap)
            remap("s", "[S]ymbols", function() vim.lsp.buf.workspace_symbol() end, opts)
        end, opts)
        wk.writeBuf()
    end
    ---@diagnostic disable-next-line: unused-local
    lsp.on_attach(onAttach)
    if jit.os == "Windows" then
        require('lspconfig').arduino_language_server.setup({
            -- cmd = { "node", --[[ "run", ]] "C:/Users/woodc/ar_ls_inter_client/index.js" },
            cmd = { "C:\\Users\\woodc\\AppData\\Local\\nvim-data\\mason\\bin\\arduino-language-server.cmd", "-clangd",
                "C:\\Users\\woodc\\AppData\\Local\\nvim-data\\mason\\bin\\clangd.cmd", "-cli-config",
                "C:\\Users\\woodc\\appdata\\local\\arduino15\\arduino-cli.yaml", "-fqbn", "arduino:avr:pro", "-log",
                "true" },
        })
    else
        require('lspconfig').arduino_language_server.setup({
            cmd = { "node", --[[ "run", ]] "/mnt/c/Users/woodc/ar_ls_inter_client/index.js" },
        })
    end
    require('lspconfig').lua_ls.setup({
        settings = {
            Lua = {
                hint = {
                    enable = true,
                },
            },
        },
    });
    require("lspconfig").rust_analyzer.setup({

    });
    require("lspconfig").clangd.setup({

    });
    require("lspconfig").tsserver.setup({

    });
    require("lspconfig").svelte.setup({

    });
    require("lspconfig").prosemd_lsp.setup({

    });
    require("lspconfig").gopls.setup({

    });
    require("lspconfig").vimls.setup({})
    lsp.setup()


    vim.diagnostic.config({
        virtual_text = true
    })
end)
