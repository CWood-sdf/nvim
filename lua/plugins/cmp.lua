return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    keys = { ":" },
    config = function()
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
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ["<C-Space>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
        }

        cmp_mappings["<Tab>"] = nil
        cmp_mappings["<S-Tab>"] = nil

        -- local cmp_action = require("lsp-zero").cmp_action()
        --
        -- cmp_mappings["<C-d>"] = cmp_action.luasnip_jump_forward()

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
                        ignore_cmds = { 'lua', 'Man', '!' }
                    }
                }
            })
        })

        ---@diagnostic disable-next-line: missing-fields
        cmp.setup({
            enabled = true,
            sources = cmp.config.sources({
                { name = "neorg" },
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
    end,
    dependencies = {
        { "hrsh7th/nvim-cmp" },     -- Required
        { "hrsh7th/cmp-nvim-lsp" }, -- Required
        { "hrsh7th/cmp-cmdline" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "L3MON4D3/LuaSnip" }, -- Required
        { "rafamadriz/friendly-snippets" },
    },
}
