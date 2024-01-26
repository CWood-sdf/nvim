return {
    'CWood-sdf/git-conflict.nvim',
    version = "*",
    opts = {
        default_mappings = {
            ours = "<leader>gco",
            theirs = "<leader>gct",
            both = "<leader>gcb",
            none = "<leader>gc0",
            next = "<leader>gcn",
            prev = "<leader>gcp",
        },
    },
    cmd = {
        "GitConflictListQf",
        "GitConflictNextConflict",
        "GitConflictPrevConflict",
    },
    keys = { "<leader>g" },
    lazy = false,
    dev = true,
}
