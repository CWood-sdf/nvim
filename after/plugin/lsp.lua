local lsp = require("lsp-zero")
local wk = require("stuff.wkutils")
lsp.preset("recommended")

lsp.ensure_installed({
    'rust_analyzer',
    'lua_ls',
    'clangd',
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-CR>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

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
    }
})

lsp.on_attach(function(client, bufnr)
    --vim.lsp.buf.inlay_hint(bufnr, true)
    -- vim.diagnostic.enable(bufnr)
    -- vim.diagnostic.show(nil, bufnr, nil, {
    --     virtual_text = true
    -- })
    local opts = { buffer = bufnr, noremap = false }
    wk.remapNoGroup("n", "K", "Hover", function() vim.lsp.buf.hover() end, opts)
    wk.makeGroup("n", "<leader>v", "LSP", function(remap)
        remap("d", "[D]iagnostic float", function() vim.diagnostic.open_float() end, opts)
        remap("h", "[H]over (K)", function() vim.lsp.buf.hover() end, opts)
        remap("a", "[A]ction", function() vim.lsp.buf.code_action() end, opts)
        remap("n", "[n]ext diagnostic ([d)", function() vim.diagnostic.goto_next() end, opts)
        remap("p", "[p]revious diagnostic (]d)", function() vim.diagnostic.goto_prev() end, opts)
        remap("s", "[S]ignature help (<C-h>)", function() vim.lsp.buf.signature_help() end, opts)
    end)
    wk.makeGroup("n", '<leader>vr', "ref/ren", function(remap)
        remap("r", "[R]eferences", function() vim.lsp.buf.references() end, opts)
        remap("n", "Re[n]ame", function() vim.lsp.buf.rename() end, opts)
    end)
    wk.makeGroup("n", "<leader>vw", "LSP Workspace", function(remap)
        remap("s", "Symbols", function() vim.lsp.buf.workspace_symbol() end, opts)
    end)
    wk.writeBuf()
end)
lsp.setup()


vim.diagnostic.config({
    virtual_text = true
})
