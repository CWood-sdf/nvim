local opts = {
    -- log_level = "trace",
    tasks = {
    },
    edit_mode = "buffer",        -- buffer, tab, split, vsplit
    config_file = ".tasks.json", -- name of json config file for project/global config
    config_order = {             -- default: { project, global, opts }.  Order in which
        -- tasks are aggregated
        "project",               -- .task.json in project directory
        "global",                -- .tasks.json in stdpath('data')
        "opts",                  -- tasks defined in setup opts
    },
    tag_source = true,           -- display #project, #global, or #opt after tags
    global_tokens = {
        ["${cwd}"] = vim.fn.getcwd,
        ["${do-the-needful}"] = "please",
        ["${projectname}"] = function()
            return vim.fn.system("basename $(git rev-parse --show-toplevel)")
        end,
    },
    ask_functions = {
        get_cwd = function()
            return vim.fn.getcwd()
        end,
        current_file = function()
            return vim.fn.expand("%")
        end,
    },
}

return {
    "catgoose/do-the-needful.nvim",
    event = { "User SpaceportDone", "DirChangedPre" },
    keys = {
        { "<leader>;", [[<cmd>Telescope do-the-needful please<cr>]], "n" },
        { "<leader>:", [[<cmd>Telescope do-the-needful<cr>]],        "n" },
    },
    dependencies = "nvim-lua/plenary.nvim",
    init = function()
        require("do-the-needful").setup(opts)
        -- require("do-the-needful.config").telescope_setup(opts)
        local telescope = require('telescope')
        telescope.load_extension("do-the-needful")
    end,
    -- dev = true,
}
