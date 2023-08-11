local dap = require 'dap'
function Test()
    vim.print(vim.tbl_keys(dap.configurations))
end
