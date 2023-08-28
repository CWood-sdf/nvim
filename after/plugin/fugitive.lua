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

local gitAugroup = vim.api.nvim_create_augroup("Git", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "fugitive://*" },
    group = gitAugroup,
    callback = function()
        vim.print("Fugitive loaded")
        wk.useGroup("n", "<leader>g", function(remap)
            remap("a", "[A]dd all", function()
                vim.cmd("Git add .")
            end, {
                buffer = vim.api.nvim_get_current_buf(),
                noremap = false
            });
        end);

        wk.writeBuf()
    end
})

wk.writeBuf()
