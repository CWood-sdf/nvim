-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require("lazy").setup({
    {
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
    },
    {
        'jim-fx/sudoku.nvim',
        cmd = 'Sudoku',
        opts = {},
    },
    {
        'alec-gibson/nvim-tetris',
        cmd = 'Tetris',
    },
    {
        "ziontee113/color-picker.nvim",
        opts = {},
        cmd = { "PickColor", "PickColorInsert" },
    },
    {
        "CWood-sdf/keyRecorder",
        event = "VeryLazy",
        dev = true,
        opts = {},
    },
    {
        "ThePrimeagen/vim-apm",
        cmd = "VimApm",
    },
    {
        "Eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        config = function()
            local animation = {
                fps = 20,
                name = "bounce",
            }
            function animation.init(grid)
                for i = 1, #grid do
                    for j = 1, #grid[i] do
                        if grid[i][j].char ~= " " then
                            local velBound = 1
                            local velX = math.random(-velBound, velBound)
                            local velY = math.random(-velBound, velBound)
                            while velX == 0 and velY == 0 do
                                velX = math.random(-velBound, velBound)
                                velY = math.random(-velBound, velBound)
                            end
                            grid[i][j].velocity = { x = velX, y = velY }
                            -- grid[i][j].hl_group = { "@comment", "
                        else
                            grid[i][j].char = " "
                        end
                    end
                end
            end

            function animation.update(grid)
                local skipList = {}
                for i = 1, #grid do
                    for j = 1, #grid[i] do
                        if skipList[i] == nil then
                            skipList[i] = {}
                        end
                        if skipList[i][j] then
                            goto continue
                        end
                        if grid[i][j].char ~= " " then
                            local vel = grid[i][j].velocity
                            local x = i
                            local y = j
                            local newX = x + vel.x
                            local newY = y + vel.y
                            -- print("yo")
                            -- print(newX, newY)
                            if newX < 1 then
                                vel.x = 1
                                newX = 1
                            end
                            if newY < 1 then
                                vel.y = 1
                                newY = 1
                            end
                            if newX > #grid then
                                vel.x = -1
                                newX = #grid
                            end
                            if newY > #grid[i] then
                                vel.y = -1
                                newY = #grid[i]
                            end
                            -- print(newX, newY)
                            if grid[newX][newY].char == " " then
                                local temp = grid[newX][newY].hl_group
                                grid[newX][newY].hl_group = grid[x][y].hl_group
                                grid[x][y].hl_group = temp
                                grid[newX][newY].char = grid[x][y].char
                                grid[x][y].char = " "
                                grid[newX][newY].velocity = grid[x][y].velocity
                                grid[x][y].velocity = { x = 0, y = 0 }
                                if skipList[newX] == nil then
                                    skipList[newX] = {}
                                end
                                skipList[newX][newY] = true
                            else
                                -- print("hi")
                                grid[x][y].velocity = { x = -vel.x, y = -vel.y }
                            end
                        end
                        ::continue::
                    end
                end
                return true
            end

            require("cellular-automaton").register_animation(animation)
        end,
    },
    --ssr
    {
        "cshuaimin/ssr.nvim",
        keys = "<leader>s",
        config = function()
            require("ssr").setup({})
        end,
    },
    --refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("refactoring").setup({})
        end,
        cmd = "Refactor",
    },
    -- startuptime
    {
        "dstein64/vim-startuptime",
        -- lazy-load on a command
        cmd = "StartupTime",
        -- init is called during startup. Configuration for vim plugins typically should be set in an init function
        init = function()
            vim.g.startuptime_tries = 10
        end,
    },
    -- {
    -- 	"mfussenegger/nvim-lint",
    -- 	event = "BufEnter *.*",
    -- 	config = function()
    -- 		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    --
    -- 			callback = function()
    -- 				require("lint").try_lint()
    -- 			end,
    -- 		})
    -- 		require("lint").linters_by_ft = {
    -- 			javascript = { "eslint_d" },
    -- 			typescript = { "eslint_d" },
    -- 			typescriptreact = { "eslint_d" },
    -- 			json = { "jsonlint" },
    -- 			css = { "stylelint" },
    -- 			markdown = { "markdownlint", "vale" },
    -- 		}
    -- 	end,
    -- },
    --trouble
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = {},
    },
    --colorizer
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre *.*",
        config = function()
            require("colorizer").setup()
            require("colorizer").setup({
                "*",
                markdown = { names = false },
            })
        end,
    },
    --oil
    {
        "stevearc/oil.nvim",
        opts = {
            view_options = {
                show_hidden = true,
            },
            -- skip_confirm_for_all_edits = true,
            keymaps = {
                ["<C-s>"] = function()
                    vim.cmd.w()
                end,
            },
        },
        cmd = "Oil",
    },
    --conform
    {
        "stevearc/conform.nvim",
        opts = {
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 1000,
            },
            formatters_by_ft = {
                -- lua = { "stylua" },
                cpp = { "clang-format" },
                c = { "clang-format" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                markdown = { "prettier" },
                yaml = { "prettier" },
            },
            notify_on_error = true,
        },
        event = "BufReadPre *.*",
    },
    --fidget
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
    -- vimbegood
    {
        "ThePrimeagen/vim-be-good",
        cmd = "VimBeGood",
    },
    --arduino
    {
        "stevearc/vim-arduino",
        ft = (function()
            if jit.os == "Windows" then
                return "sdjfaksdhgksd"
            end
            return "arduino"
        end)(),
    },

    -- remember keymaps
    {
        "folke/which-key.nvim",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup({})
        end,
        lazy = false,
    },
    -- pineapple
    {
        "CWood-sdf/pineapple",
        dependencies = require("stuff.pineapple"),
        opts = {
            installedRegistry = "stuff.pineapple",
            colorschemeFile = "after/plugin/theme.lua",
        },
        cmd = "Pineapple",
        -- priority = 1000,
        -- commit = "d2ad4b8c012eaaa37ac043d78fce2bee155efda6",
        dev = true,
    },
    -- spaceport
    {
        "CWood-sdf/spaceport.nvim",
        config = function()
            local opts = {
                replaceDirs = { { "~/projects", "_" }, { "/mnt/c/Users/woodc", "$" }, { "~/.local/share/nvim", "@" } },
                replaceHome = true,
                projectEntry = "Oil .",
                lastViewTime = "yesterday",
                sections = {
                    "_global_remaps",
                    "name_blue_green",
                    "remaps",
                    "recents",
                    "hacker_news",
                },
            }
            require("spaceport").setup(opts)
        end,
        dev = true,
        -- priority = 1000,
    },
    -- md preview
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        config = function()
            vim.fn["mkdp#util#install"]()
        end,
    },

    -- line at bottom
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = function()
            require("stuff.lualine")
        end,
    },

    -- just fancy icons for dap
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        -- event = "VeryLazy"
    },

    --autocomment
    {
        "numToStr/Comment.nvim",
        event = "BufReadPre *.*",
        config = function()
            require("Comment").setup()
            require("Comment.ft").set("maple", "// %s")
        end,
    },

    -- Debugger stuff
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "jay-babu/mason-nvim-dap.nvim",
            "williamboman/mason.nvim",
        },
        config = require("stuff.dap_setup"),
        cmd = { "DapContinue", "DapToggleBreakpoint" },
        keys = { "<leader>d" },
    },

    -- {
    -- 	"jay-babu/mason-nvim-dap.nvim",
    -- 	dependencies = {
    -- 		"mfussenegger/nvim-dap",
    -- 		"williamboman/mason.nvim",
    -- 	},
    -- 	lazy = true,
    -- },
    --
    -- {
    -- 	"mfussenegger/nvim-dap",
    -- 	lazy = true,
    -- },

    -- fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        keys = "<leader>f",
        version = "0.1.3",
        opts = {},
        -- or                            , branch = '0.1.x',
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },

    -- highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPre *.*",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
        },
        config = function()
            require("stuff.ts_setup")()
        end,
        -- event = "VeryLazy",
        -- build = ':TSUpdate'
    },

    -- epic fast file goto
    {
        "ThePrimeagen/harpoon",
        event = { "User SpaceportDone" },
        config = function()
            local mark = require("harpoon.mark")

            local ui = require("harpoon.ui")
            local wk = require("stuff.wkutils")

            wk.remapNoGroup("n", "<leader>a", "Toggle Harpoon", mark.toggle_file, {})
            wk.writeBuf()

            wk.remapNoGroup("n", "<C-e>", "Harpoon quick menu", ui.toggle_quick_menu)
            wk.writeBuf()
            wk.remapNoGroup("n", "<leader>h", "{count}[H]arpoon nav", function()
                if vim.v.count == nil or vim.v.count == 0 then
                    print("No count provided for epic harpoon nav")
                elseif vim.v.count > mark.get_length() then
                    print("Count provided is too large for epic harpoon nav")
                else
                    ui.nav_file(vim.v.count)
                end
            end)
            wk.writeBuf()
            require("harpoon.tabline").setup({})
            vim.cmd("hi! link HarpoonActive TablineSel")
            vim.cmd("hi! link HarpoonNumberActive TablineSel")
            vim.cmd("hi! link HarpoonNumberInactive Tabline")
            vim.cmd("hi! link HarpoonInactive Tabline")
        end,
    },

    -- undotree
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle", "UndotreeShow" },
    },

    -- git
    {
        "tpope/vim-fugitive",
        cmd = "Git",
    },

    { -- Optional
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {},
    },
    --cmp
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
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
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "L3MON4D3/LuaSnip" }, -- Required
            { "rafamadriz/friendly-snippets" },
        },
    },
    -- lsp
    {
        "VonHeikemen/lsp-zero.nvim",
        --branch = 'v2.x',
        dependencies = {
            -- LSP Support
            {
                "neovim/nvim-lspconfig",
            },                                       -- Required
            { "williamboman/mason-lspconfig.nvim" }, -- Optional
            { "williamboman/mason.nvim" },           -- Optional

            -- Autocompletion
            -- { "folke/neodev.nvim" },
        },
        event = "BufReadPre *.*",
        config = function()
            require("stuff.lsp_setup")()
            -- vim.cmd("e")
        end,
    },
    -- neodev
    {
        "folke/neodev.nvim",
        event = "BufReadPre *.lua",
        opts = {},
    },

    -- copilot
    {
        "github/copilot.vim",
        config = function()
            if vim.fn.executable("bun") == 1 then
                vim.cmd("let g:copilot_node_command = 'bun'")
            end
            -- vim.cmd("let g:copilot_filetypes.markdown = v:true")
            vim.cmd("let g:copilot_filetypes = { 'markdown': v:true }")
        end,
        cmd = "Copilot",
    },
}, {
    dev = {
        path = (function()
            if jit.os == "Windows" then
                return "C:\\Users\\woodc\\"
            end
            return "~/projects/"
        end)(),
    },
    -- install = {
    -- 	-- missing = false,
    -- },
    checker = {
        enabled = true,
        frequency = 600,
        notify = false,
    },
})
