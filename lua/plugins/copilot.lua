return {
    "github/copilot.vim",
    config = function()
        vim.keymap.set("i", "<C-L>", "<Plug>(copilot-accept-word)")
        -- if vim.fn.executable("bun") == 1 then
        -- vim.cmd("let g:copilot_node_command = 'bun'")
        -- end
        -- vim.cmd("let g:copilot_filetypes.markdown = v:true")
        vim.cmd("let g:copilot_filetypes = { 'markdown': v:true }")
    end,
    init = function()
        vim.api.nvim_create_autocmd({ "User" }, {
            pattern = "SpaceportDone",
            callback = function()
                vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
            end,
        })
    end,
    cmd = "Copilot",
    -- enabled = false,
}
