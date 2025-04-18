return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    keys = { ":" },
    config = function()
        local wk = require("stuff.wkutils")
        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_mappings = {
            ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
            ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
            ["<Down>"] = cmp.mapping.select_next_item(cmp_select),
            ["<Up>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<C-y>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
            ["<C-Space>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
        }

        cmp_mappings["<Tab>"] = nil
        cmp_mappings["<S-Tab>"] = nil

        -- local cmp_action = require("lsp-zero").cmp_action()
        --
        -- cmp_mappings["<C-d>"] = cmp_action.luasnip_jump_forward()

        cmp.setup.filetype({ "sql" }, {
            sources = {
                { name = "vim-dadbod-completion" },
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(
                {
                    ["<C-j>"] = {
                        c = function()
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                cmp.complete()
                            end
                        end,
                    },
                    ["<C-k>"] = {
                        c = function()
                            if cmp.visible() then
                                cmp.select_prev_item()
                            else
                                cmp.complete()
                            end
                        end,
                    },
                    ["<C-Space>"] = {
                        c = cmp.mapping.confirm({ select = true })
                    },
                }
            ),
            sources = cmp.config.sources({
                -- { name = 'path' }
                -- { name = 'cmdline' }
            }, {
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            })
        })

        ---@diagnostic disable-next-line: missing-fields
        cmp.setup({
            enabled = true,
            sources = cmp.config.sources({
                { name = "lsp" },
                { name = "git" },
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, { { name = "buffer" }, { name = "neorg" } }),
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
        require("cmp_git").setup()
        local ls = require('luasnip')
        wk.remapNoGroup({ "i", "s" }, "<C-h>", "Snip left", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end)
        wk.remapNoGroup({ "i", "s" }, "<C-l>", "Snip right", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end)
        wk.writeBuf()
    end,
    dependencies = {
        { "hrsh7th/nvim-cmp" },     -- Required
        { "hrsh7th/cmp-nvim-lsp" }, -- Required
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-buffer" },
        { "petertriho/cmp-git" },
        { "hrsh7th/cmp-path" },
        { "L3MON4D3/LuaSnip" }, -- Required
        { "rafamadriz/friendly-snippets" },
    },
}
