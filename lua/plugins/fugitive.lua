return {
    "tpope/vim-fugitive",
    cmd = "Git",
    init = function()
        local wk = require("stuff.wkutils")

        wk.makeGroup("n", "<leader>g", "[G]it", function(remap)
            remap("s", "[S]tatus", vim.cmd.Git)
            remap("P", "[P]ull", function()
                vim.cmd("Git pull")
            end)
            remap("p", "[P]ush", function()
                vim.cmd("Git push")
            end)
        end)

        wk.writeBuf()
        local used = {}

        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            pattern = "fugitive://*",
            callback = function(_)
                local buf = vim.api.nvim_get_current_buf()
                if used[buf] then
                    return
                end
                used[buf] = true
                local opts = {
                    buffer = buf,
                }
                vim.fn.timer_start(100, function()
                    wk.makeGroup("n", "<leader>g", "[G]it", function(remap)
                        remap("a", "[A]dd all", function()
                            vim.cmd("Git add .")
                        end)
                        remap("C", "[C]ommit all", function()
                            local msg = vim.fn.input("Commit message: ")
                            vim.cmd("Git add .")
                            vim.cmd('Git commit -m "' .. msg .. '"')
                        end)
                    end, opts)

                    wk.writeBuf()
                end)
            end,
        })
    end,
}
