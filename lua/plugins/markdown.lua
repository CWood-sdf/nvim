return {
    "iamcco/markdown-preview.nvim",
    -- cmd = 'MarkdownPreview',
    ft = "markdown",
    config = function()
        vim.fn["mkdp#util#install"]()
    end,
}
