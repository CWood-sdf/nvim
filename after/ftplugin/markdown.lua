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
