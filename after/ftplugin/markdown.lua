local wk = require("stuff.wkutils")
-- print(vim.inspect(args))
local bufnr = vim.api.nvim_get_current_buf()
local opts = {
    buffer = bufnr,
    noremap = true,
}
wk.makeGroup("n", "<leader>m", "[M]arkdown Preview", function(remap)
    remap("p", "[P]review Start", function()
        vim.cmd("MarkdownPreview")
    end, opts)
    remap("s", "[S]top", function()
        vim.cmd("MarkdownPreviewStop")
    end, opts)
    remap("t", "[T]oggle", function()
        vim.cmd("MarkdownPreviewToggle")
    end, opts)
end, opts)
wk.writeBuf()
vim.keymap.set("n", "<leader>gd", function()
    local buf = vim.api.nvim_get_current_buf()

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local line = vim.api.nvim_get_current_line()


    local match = line:match("^..*#")
    local word = ""
    if match ~= nil then
        local i = #match + 1
        while line:sub(i, i):match("%W") == nil do
            word = word .. line:sub(i, i)
            i = i + 1
        end
    else
        return
    end
    print(word)
    local matchStrength = 0
    local matchIndex = 0
    for i, v in ipairs(lines) do
        if v:sub(1, 1) ~= "#" then
            goto continue
        end
        if v:match(word) ~= nil then
            local strength = #word / #v
            if strength > matchStrength then
                matchStrength = strength
                matchIndex = i
            end
        end
        ::continue::
    end
    if matchIndex ~= 0 then
        vim.api.nvim_feedkeys("m'", "n", false)
        vim.cmd(matchIndex .. "")
    end
end, {
    buffer = vim.api.nvim_get_current_buf()
})
