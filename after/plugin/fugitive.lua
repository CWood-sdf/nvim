local wk = require("stuff.wkutils");

wk.makeGroup("n", "<leader>g", "[G]it", function(remap)
    remap("s", "[S]tatus", vim.cmd.Git);
    remap("p", "[P]ush", function()
        vim.cmd("Git push")
    end);
    remap("c", "[C]ommit", function()
        vim.cmd("Git commit")
    end);
end)


wk.writeBuf()

local gitAuGrp = vim.api.nvim_create_augroup("Git", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {

    pattern = "fugitive://*",
    callback = function(ev)
        wk.useGroup("n", "<leader>g", function(remap)
            local opts = { noremap = true, buffer = vim.api.nvim_get_current_buf() }
            remap("a", "[A]dd all", function()
                vim.cmd("Git add .")
            end, opts);
        end)
        wk.writeBuf()
    end,
    group = gitAuGrp
})
