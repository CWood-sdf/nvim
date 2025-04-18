return {
    enabled = false,
    "ggandor/leap.nvim",
    config = function()
        vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
        vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-backward)')
        vim.keymap.set({ 'n', 'x', 'o' }, 'gS', '<Plug>(leap-from-window)')
    end,

}
