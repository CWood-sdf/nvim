return {
    'akinsho/git-conflict.nvim',
    version = "*",
    opts = {
        default_mappings = {
            ours = "<leader>gCo",
            theirs = "<leader>gCt",
            both = "<leader>gCb",
            none = "<leader>gC0",
            next = "<leader>gCn",
            prev = "<leader>gCp",
        },
    },
    event = "VeryLazy",
    cmd = {
        "GitConflictListQf",
        "GitConflictNextConflict",
        "GitConflictPrevConflict",
    },
    keys = { "<leader>gC" },
}
