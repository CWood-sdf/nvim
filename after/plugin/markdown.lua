local wk = require("stuff.wkutils");
vim.fn["mkdp#util#install"]()

local mdAugroup = vim.api.nvim_create_augroup("mdPreview", {
    clear = true
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*.md",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local opts = {
            buffer = bufnr,
            noremap = true,
        };
        wk.makeGroup("n", "<leader>m", "[M]arkdown", function(remap)
            remap("p", "[P]review", function()
                vim.cmd("MarkdownPreview")
            end, opts);
            remap("s", "[S]top", function()
                vim.cmd("MarkdownPreviewStop")
            end, opts);
            remap("t", "[T]oggle", function()
                vim.cmd("MarkdownPreviewToggle")
            end, opts);
        end)
        wk.writeBuf()
    end,
    group = mdAugroup
})
