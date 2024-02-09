return {
    "mfussenegger/nvim-lint",
    config = function()
        require('lint').linters_by_ft = {
            -- cpp = { 'cpplint' },
            cpp = { 'clang-tidy' },
            cmake = { 'cmakelint' },
        }
    end,
    keys = { {
        "<C-l>",
        function()
            require('lint').try_lint()
        end
    } },

}
