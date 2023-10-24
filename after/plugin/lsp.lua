require("future").load("lsp", function()
    vim.cmd("Lazy! load lsp-zero.nvim")
    vim.cmd("Lazy! load neodev.nvim")
    local lsp = require("lsp-zero")
    local wk = require("stuff.wkutils")
    lsp.preset("recommended")
    require('neodev').setup()

    lsp.ensure_installed({
        'rust_analyzer',
        'clangd',
        'lua_ls',
    })

    -- Fix Undefined global 'vim'
    lsp.nvim_workspace()


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
    })

    cmp_mappings['<Tab>'] = nil
    cmp_mappings['<S-Tab>'] = nil

    -- cmp.setup({
    --     sources = {
    --         { name = "nvim_lsp" },
    --     },
    --     mapping = cmp_mappings,
    --     snippet = {
    --         expand = function(args)
    --             require("luasnip").lsp_expand(args.body)
    --         end,
    --     },
    --     formatting = {
    --         format = function(entry, vim_item)
    --             vim_item.kind = lsp.protocol.CompletionItemKind[vim_item.kind]
    --             return vim_item
    --         end,
    --     },
    -- })

    lsp.setup_nvim_cmp({
        mapping = cmp_mappings
    })


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
        end)
        wk.makeGroup("n", '<leader>vr', "ref/ren", function(remap)
            remap("r", "[R]eferences", function() vim.lsp.buf.references() end, opts)
            remap("n", "Re[n]ame", function() vim.lsp.buf.rename() end, opts)
        end)
        wk.makeGroup("n", "<leader>vw", "Workspace", function(remap)
            remap("s", "[S]ymbols", function() vim.lsp.buf.workspace_symbol() end, opts)
        end)
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
    })
    lsp.setup()


    vim.diagnostic.config({
        virtual_text = true
    })
end)
