return {
    "numToStr/Comment.nvim",
    event = "BufReadPre *.*",
    -- enabled = false,
    config = function()
        require("Comment").setup()
        require("Comment.ft").set("maple", "// %s")
    end,
}
