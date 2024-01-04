return function()
    require("nvim-treesitter.install").compilers = { "clang" }

    local selectTextObjects = {}
    local function addTextObject(key, query, desc, around, inner)
        if around then
            selectTextObjects["a" .. key] = { query = query .. ".outer", desc = desc }
        end
        if inner then
            selectTextObjects["i" .. key] = { query = query .. ".inner", desc = desc }
        end
    end
    addTextObject("f", "@function", "Function", true, true)
    addTextObject("c", "@class", "Class", true, true)
    addTextObject("s", "@scope", "Scope", true, true)
    addTextObject("a", "@parameter", "Parameter", true, true)
    addTextObject("l", "@loop", "Loop", true, true)
    addTextObject("i", "@conditional", "Conditional", true, true)
    require("nvim-treesitter.configs").setup({
        modules = {},

        ignore_install = {},

        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = { "bash", "rust", "zig", "c", "javascript", "typescript", "lua", "vim", "vimdoc", "query" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        highlight = {
            enable = true,

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = selectTextObjects,
                -- You can choose the select mode (default is charwise 'v')
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * method: eg 'v' or 'o'
                -- and should return the mode ('v', 'V', or '<c-v>') or a table
                -- mapping query_strings to modes.
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "V",  -- linewise
                    ["@class.outer"] = "<c-v>", -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding or succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                --
                -- Can also be a function which gets passed a table with the keys
                -- * query_string: eg '@function.inner'
                -- * selection_mode: eg 'v'
                -- and should return true of false
                -- include_surrounding_whitespace = true,
            },
            move = {
                enable = true,
                goto_next_start = {
                    ["]f"] = { query = "@function.outer", desc = "Next function" },
                    ["]c"] = { query = "@class.outer", desc = "Next class" },
                    --
                    -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
                    ["]l"] = { query = { "@loop.inner", "@loop.outer" }, desc = "Next loop" },
                    --
                    -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                    -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                    ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                    ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                    ["]i"] = { query = "@conditional.outer", desc = "Next conditional" },
                },
                goto_next_end = {
                    ["]F"] = { query = "@function.outer", desc = "Next function" },
                    ["]C"] = { query = "@class.outer", desc = "Next class" },
                    --
                    -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
                    ["]L"] = { query = { "@loop.inner", "@loop.outer" }, desc = "Next loop" },
                    --
                    -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                    -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                    ["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                    ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
                    ["]I"] = { query = "@conditional.outer", desc = "Next conditional" },
                },
                goto_previous_start = {
                    ["[f"] = { query = "@function.outer", desc = "Previous function" },
                    ["[c"] = { query = "@class.outer", desc = "Previous class" },
                    --
                    -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
                    ["[l"] = { query = { "@loop.inner", "@loop.outer" }, desc = "Previous loop" },
                    --
                    -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                    -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                    ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
                    ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
                    ["[i"] = { query = "@conditional.outer", desc = "Previous conditional" },
                },
                goto_previous_end = {
                    ["[F"] = { query = "@function.outer", desc = "Previous function" },
                    ["[C"] = { query = "@class.outer", desc = "Previous class" },
                    --
                    -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
                    ["[L"] = { query = { "@loop.inner", "@loop.outer" }, desc = "Previous loop" },
                    --
                    -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                    -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                    ["[S"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
                    ["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
                    ["[I"] = { query = "@conditional.outer", desc = "Previous conditional" },
                },
                -- Below will go to either the start or the end, whichever is closer.
                -- Use if you want more granular movements
                -- Make it even more gradual by adding multiple queries and regex.
                -- goto_next = {
                --     ["]i"] = "@conditional.outer",
                -- },
                -- goto_previous = {
                --     ["[i"] = "@conditional.outer",
                -- }
            },
        },
    })

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    vim.cmd("hi! link TreesitterContext Normal")
    require("treesitter-context").setup({
        seperator = true,
    })
    local wkutils = require("stuff.wkutils")
    wkutils.useGroup("n", "[", function(remap)
        remap("t", "ts context", function()
            require("treesitter-context").go_to_context()
        end)
    end)
    vim.treesitter.language.register("maple", "maple")
    ---@diagnostic disable-next-line: inject-field
    parser_config.maple = {
        install_info = {
            url = "~/projects/maple/tree-sitter-maple", -- local path or git repo
            files = { "src/parser.c" },                 -- note that some parsers also require src/scanner.c or src/scanner.cc
            -- optional entries:
            branch = "main",                            -- default branch in case of git repo if different from master
            generate_requires_npm = false,              -- if stand-alone parser without npm dependencies
            requires_generate_from_grammar = true,      -- if folder contains pre-generated src/parser.c
        },
        filetype = "maple",                             -- if filetype does not match the parser name
    }
end
