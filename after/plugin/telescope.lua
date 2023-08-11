local builtin = require('telescope.builtin')

local wk = require("stuff.wkutils")

wk.makeGroup("n", "<leader>f", "[F]ile", function(remap)
    remap("f", "[F]ind", builtin.find_files);
    remap("s", "[S]earch", builtin.live_grep);
    remap("b", "[B]uffers", builtin.buffers);
    remap("h", "[H]elp", builtin.help_tags);
    remap("c", "[C]ommands", builtin.commands);
    remap("t", "[T]ags", builtin.tags);
    remap("r", "[R]ecent", builtin.oldfiles);
    remap("g", "[G]it files (<C-p>)", builtin.git_files);
end)
wk.writeBuf()
