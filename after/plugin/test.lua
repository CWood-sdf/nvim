local dap = require 'dap'
function Test()
    vim.print(dap.active)

    -- type = adapter name
    -- vim.print(dap.configurations.rust[1].type)

    -- vim.print(vim.tbl_keys(da))
end
