local wk = require("stuff.wkutils")
-- vim.g.copilot_node_command = "~/.bun/bin/bun"
-- vim.cmd("let g:copilot_filetypes = {'markdown': v:true}")


vim.keymap.set("n", "<M-n>", function()
    vim.cmd("vertical resize -5")
end)
vim.keymap.set("n", "<M-m>", function()
    vim.cmd("vertical resize +5")
end)
vim.keymap.set("n", "<M-,>", function()
    vim.cmd("vertical resize -2")
end)
vim.keymap.set("n", "<M-.>", function()
    vim.cmd("vertical resize +2")
end)
vim.keymap.set("n", "<M-b>", function()
    vim.cmd("horizontal resize +2")
end)
vim.keymap.set("n", "<M-s>", function()
    vim.cmd("horizontal resize -2")
end)

wk.makeGroup("n", "do", "Over", function(remap)
    remap("%", "match", function()
        local charUnderCursor = vim.fn.getline("."):sub(vim.fn.col(".") or 1, vim.fn.col("."))
        local allowedChars = "()[]{}"
        if string.find(allowedChars, charUnderCursor, 1, true) then
            wk.feedKeys("%x``x", "n")
        end
    end)
end)

wk.makeGroup("n", "<leader>t", "[T]erminal", function(remap)
    remap("t", "[T]mux split right", function()
        vim.cmd("Spaceport horizontalSplit")
    end)
    remap("T", "[T]mux split down", function()
        vim.cmd("Spaceport verticalSplit")
    end)
    remap("o", "[O]pen", function()
        vim.cmd("vsplit")
        vim.cmd("winc l")
        vim.cmd("terminal")
    end)
    remap("r", "[R]epeat", ":winc l<CR>i<Up><CR><C-\\><C-n>:winc h<CR>", { noremap = true })
    remap("n", "Repeat [n]o leave", ":winc l<CR>i<Up><CR><C-\\><C-n>", { noremap = true })
    remap("c", "[c]lear lines", "<cmd>set scrollback=1<CR>iclear<CR><C-\\><C-n><cmd>set scrollback=10000<CR>",
        { noremap = true })
end)

wk.makeGroup({ "t", "n" }, "<leader>t", "terminal", function(remap)
    remap("j", "Floaterminal", function()
        vim.cmd.stopinsert()
        if vim.v.count ~= 0 then
            vim.cmd("Floaterminal toggle " .. vim.v.count)
        else
            vim.cmd("Floaterminal toggle")
        end
    end, { noremap = true })
    remap("k", "Floaterminal next", function()
        vim.cmd.stopinsert()
        vim.cmd("Floaterminal next")
    end, { noremap = true })
    remap("J", "Floaterminal prev", function()
        vim.cmd.stopinsert()
        vim.cmd("Floaterminal prev")
    end, { noremap = true })
    remap("l", "Floaterminal rename", function()
        vim.cmd.stopinsert()
        local name = vim.fn.input("new name: ")
        if vim.v.count ~= 0 then
            vim.cmd("Floaterminal rename " .. vim.v.count .. ' "' .. name .. '"')
        else
            vim.cmd("Floaterminal rename " .. Floaterminal.index .. ' "' .. name .. '"')
        end
    end, { noremap = true })
    remap("d", "Floaterminal delete", function()
        vim.cmd.stopinsert()
        if vim.v.count ~= 0 then
            vim.cmd("Floaterminal remove " .. vim.v.count)
        else
            vim.cmd("Floaterminal remove " .. Floaterminal.index)
        end
    end, { noremap = true })
    remap("N", "Floaterminal new", function()
        vim.cmd("Floaterminal append")
    end, { noremap = true })
end)
-- vim.keymap.set("t", "<leader>tj", function()
--     vim.cmd.stopinsert()
-- end, {})

-- wk.remapNoGroup("t", "<Esc>", "Exit terminal mode", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("t", "<C-k>", "<Up>")
vim.keymap.set("t", "<C-j>", "<Down>")
vim.keymap.set("t", "<C-e>", "<C-\\><C-n>")
wk.remapNoGroup("i", "<C-e>", "Exit insert mode", "<Esc>", { noremap = true })

wk.makeGroup("n", "<leader>b", "[B]uf", function(remap)
    remap("n", "[N]umber", function()
        vim.notify(vim.api.nvim_get_current_buf() .. "")
    end)
    remap("p", "[P]ath", function()
        vim.notify(vim.fn.expand("%"))
    end)
    remap("d", "[D]elete hidden", function()
        vim.cmd("DeleteHiddenBuffers")
    end)
    remap("D", "Force [D]elete hidden", function()
        vim.cmd("DeleteHiddenBuffers!")
    end)
end)

-- window stuff
wk.makeGroup("n", "<leader>p", "[P]roject", function(remap)
    remap("v", "[V]iew", function()
        vim.cmd("Oil")
    end)
    remap("r", "[R]oot", function()
        vim.cmd("Oil " .. vim.fn.getcwd())
    end)
end)

local function count()
    if vim.v.count == 0 then
        return 1
    end
    return vim.v.count
end

wk.makeGroup("n", "]", "Next", function(remap)
    remap("t", "[T]abpage", function()
        if vim.v.count == 0 then
            vim.cmd("tabnext")
        else
            vim.cmd(count() .. "tabnext")
        end
    end)
end)
wk.makeGroup("n", "[", "Previous", function(remap)
    remap("t", "[T]abpage", function() vim.cmd(count() .. "tabprev") end)
end)

-- copy (obv)
wk.remapNoGroup("v", "<C-c>", "Copy", [["+y]], { noremap = true })
wk.remapNoGroup("n", "<C-c>", "Copy", [["+y]], { noremap = true })
wk.remapNoGroup("n", "<C-v>", "Paste", [["+p]], { noremap = true })

-- save
wk.remapNoGroup("i", "<C-s>", "Save file", function()
    vim.cmd("stopinsert")
    vim.api.nvim_command("write")
end)
wk.remapNoGroup("n", "<C-s>", "Save file", function()
    vim.api.nvim_command("write")
end)

-- somehow i accidentally broke the enter key but control enter still worked
-- so i just made it so that enter is control enter
-- idk wtf happened
vim.keymap.set("i", "<CR>", function()
    wk.feedKeys("<C-CR>", "i")
end)

-- move stuff up and down
wk.remapNoGroup("x", "<leader>k", "Move selected up", function()
    local count_ = 0
    if vim.v.count ~= nil then
        count_ = vim.v.count
    end
    if vim.v.count == 0 then
        count_ = 1
    end
    count_ = count_ + 1
    wk.feedKeys(":m '>-" .. count_ .. "<CR>", "v")
end)
wk.remapNoGroup("x", "<leader>j", "Move selected down", function()
    local count_ = 0
    if vim.v.count ~= nil then
        count_ = vim.v.count
    end
    if vim.v.count == 0 then
        count_ = 1
    end
    wk.feedKeys(":m '>+" .. count_ .. "<CR>", "v")
end)

-- useful visual mode stuff
wk.remapNoGroup("x", "D", "Void delete", function()
    wk.feedKeys('"_d', "n")
end)
wk.remapNoGroup("x", "P", "Paste last copy", function()
    wk.feedKeys('"0p', "n")
end)

wk.writeBuf()
