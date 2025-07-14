return {
    enabled = true,
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
        { 'rafamadriz/friendly-snippets' },
        { "L3MON4D3/LuaSnip" },
        { "folke/lazydev.nvim", },
    },
    event = "InsertEnter",
    keys = { ":" },

    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
            preset = 'default',
            ['<C-space>'] = { 'select_and_accept' },
            ['<C-g>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
            ['<C-j>'] = { 'select_next' },
            ['<C-k>'] = { 'select_prev' },
            ['<C-l>'] = { 'snippet_forward' },
            ['<C-h>'] = { 'snippet_backward' },
            ['<C-u>'] = { 'show_documentation' },
        },

        signature = {
            enabled = true,
            window = {
                direction_priority = { 's', 'n' },
            },
        },
        term = {
            enabled = false,
            keymap = {
                preset = 'inherit',
            },
        },

        cmdline = {
            completion = {
                menu = {
                    auto_show = true,
                },
            },
            keymap = {
                preset = 'inherit',
            },
            enabled = true,
        },

        appearance = {
            -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = {
            -- draw = {
            --     columns = {
            --         { "label",     "label_description", gap = 1 },
            --         { "kind_icon", "kind" }
            --     },
            -- },
            accept = {
                auto_brackets = {
                    enabled = false
                },
            },
            documentation = { auto_show = false }
        },

        snippets = {
            preset = 'default',
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            per_filetype = {
                sql = { 'dadbod', inherit_defaults = true },
                -- optionally inherit from the `default` sources
                -- lua = { inherit_defaults = true }
            },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
}
