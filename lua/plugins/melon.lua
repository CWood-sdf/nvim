return {
    "CWood-sdf/melon.nvim",
    event = "BufReadPre",
    opts = {
        signOpts = {
            texthl = "Comment",
        },
    },

    dev = require("stuff.isdev")("melon.nvim"),
}
