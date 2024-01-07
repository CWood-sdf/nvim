local wk = require("stuff.wkutils")

local mdAugroup = vim.api.nvim_create_augroup("mdPreview", {
    clear = true,
})

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    pattern = "*.md",
    callback = function(args)
        -- print(vim.inspect(args))
        local bufnr = args.buf
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
    end,
    group = mdAugroup,
})
