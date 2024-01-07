return {
    'nvim-neorg/neorg',
    ft = "norg",
    build = ":Neorg sync-parsers",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-neorg/neorg-telescope",
    },
    opts = {
        load = {
            ["core.defaults"] = {},  -- Loads default behaviour
            ["core.concealer"] = {}, -- Adds pretty icons to your documents
            ["core.dirman"] = {      -- Manages Neorg workspaces
                config = {
                    workspaces = {
                        notes = "~/notes",
                    },
                },
            },
            ["core.completion"] = {
                config = {
                    engine = "nvim-cmp",
                },
            },
            -- ["core.integrations.treesitter"] = {
            --     config = {
            --         configure_parsers = true,
            --     },
            -- },
            -- ["core.integrations.nvim-cmp"] = {
            --     config = {
            --         sources = {
            --             { name = "neorg" },
            --         },
            --     },
            -- },
        },
    }
}
