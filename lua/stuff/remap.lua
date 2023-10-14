local wk = require("stuff.wkutils")

vim.g.mapleader = " ";

wk.makeGroup("n", "do", "Over", function(remap)
    remap("%", "match", function()
        local charUnderCursor = vim.fn.getline("."):sub(vim.fn.col("."), vim.fn.col("."))
        local allowedChars = "()[]{}"
        if string.find(allowedChars, charUnderCursor, 1, true) then
            wk.feedKeys("%x``x", "n");
        end
    end)
end)

wk.remapNoGroup("t", "<Esc>", "Exit terminal mode", "<C-\\><C-n>", { noremap = true })
wk.remapNoGroup("t", "<C-k>", "Up arrow", "<Up>", { noremap = true })
wk.remapNoGroup("t", "<C-j>", "Down arrow", "<Down>", { noremap = true })
wk.remapNoGroup("t", "<C-e>", "Exit terminal mode", "<C-\\><C-n>", { noremap = true })

-- buffer stuff idrk y this is here but ok
wk.makeGroup("n", "<leader>b", "[B]uf", function(remap)
    remap("n", "[N]umber", function()
        print(vim.api.nvim_get_current_buf())
    end)
end)

-- window stuff
wk.makeGroup("n", "<leader>p", '[P]roject', function(remap)
    remap('v', '[V]iew', vim.cmd.Ex)
end)

-- copy (obv)
wk.remapNoGroup("x", "<C-c>", "Copy", [["+y]], { noremap = true })
wk.remapNoGroup("n", "<C-c>", "Copy", [["+y]], { noremap = true })

-- save
wk.remapNoGroup("i", "<C-s>", "Save file", function()
    vim.cmd('stopinsert')
    vim.api.nvim_command('write');
end)
wk.remapNoGroup("n", "<C-s>", "Save file", function()
    vim.api.nvim_command('write');
end)


-- somehow i accidentally broke the enter key but control enter still worked
-- so i just made it so that enter is control enter
-- idk wtf happened
vim.keymap.set("i", "<CR>", function()
    wk.feedKeys("<C-CR>", "i")
end)

-- move stuff up and down
wk.remapNoGroup('v', '<leader>k', 'Move selected up', function()
    local count = 0
    if (vim.v.count ~= nil) then
        count = vim.v.count
    end
    if (vim.v.count == 0) then
        count = 1
    end
    count = count + 1
    wk.feedKeys(":m '>-" .. count .. "<CR>", "v")
end)
wk.remapNoGroup('v', '<leader>j', 'Move selected down', function()
    local count = 0
    if (vim.v.count ~= nil) then
        count = vim.v.count
    end
    if (vim.v.count == 0) then
        count = 1
    end
    wk.feedKeys(":m '>+" .. count .. "<CR>", "v")
end)

-- useful visual mode stuff
wk.remapNoGroup("v", "D", "Void delete", function()
    wk.feedKeys("\"_d", "n")
end)
wk.remapNoGroup("v", "P", "Paste last copy", function()
    wk.feedKeys("\"0p", "n")
end)


wk.writeBuf()
