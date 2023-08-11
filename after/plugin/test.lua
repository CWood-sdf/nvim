local dap = require 'dap'
function Test()
    -- vim.print(vim.tbl_keys(dap.configurations))
    vim.print(vim.tbl_keys(require('lualine').get_config()))
end
