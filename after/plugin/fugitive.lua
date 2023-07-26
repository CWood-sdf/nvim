local wk = require("stuff.wkutils");

wk.makeGroup("n", "<leader>g", "[G]it", function(remap)
    remap("s", "[S]tatus", vim.cmd.Git);
end)

wk.writeBuf()
