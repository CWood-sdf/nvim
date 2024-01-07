return {
    "numToStr/Comment.nvim",
    event = "BufReadPre *.*",
    config = function()
        require("Comment").setup()
        require("Comment.ft").set("maple", "// %s")
    end,
}
