local wk = require("stuff.wkutils");

wk.makeGroup("n", "<leader>g", "[G]it", function(remap)
    remap("s", "[S]tatus", vim.cmd.Git);
    remap("p", "[P]ush", function()
        vim.cmd("Git push")
    end);
    remap("a", "[A]dd all", function()
        vim.cmd("Git add .")
    end);
    remap("c", "[C]ommit", function()
        vim.cmd("Git commit")
    end);
end)

wk.writeBuf()
