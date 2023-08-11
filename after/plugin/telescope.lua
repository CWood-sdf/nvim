local builtin = require('telescope.builtin')

local wk = require("stuff.wkutils")

wk.makeGroup("n", "<leader>f", "[F]ind", function(remap)
    remap("f", "[F]iles", builtin.find_files);
    remap("s", "[S]tring", builtin.live_grep);
    remap("b", "[B]uffer", builtin.buffers);
    remap("h", "[H]elp", builtin.help_tags);
    remap("c", "[C]ommands", builtin.commands);
    remap("t", "[T]ags", builtin.tags);
    remap("r", "[R]ecent file", builtin.oldfiles);
    remap("g", "[G]it files (<C-p>)", builtin.git_files);
end)
wk.writeBuf()
