---@param str string
---@return string
local function dirToSessionName(str)
    str = str:sub(2, #str)
    local s, _ = str:gsub('/', '__')
    -- s, _ = s:gsub('%\\.', '##')
    return s
end

vim.opt.ssop:append("globals")
local session_ready = false
vim.api.nvim_create_autocmd("User", {
    pattern = "SpaceportDone",
    callback = function()
        local dir = vim.fn.getcwd()
        local session = dirToSessionName(dir)
        session = vim.fn.stdpath('data') .. "/nv_sessions/" .. session .. ".vim"
        -- print(vim.fn.filereadable(session))
        if vim.fn.filereadable(session) ~= 0 then
            vim.defer_fn(function()
                vim.cmd("so " .. session)
                vim.defer_fn(function()
                    vim.cmd("set signcolumn=yes")
                    session_ready = true
                end, 10)
            end, 10)
        else
            -- vim.cmd("mks " .. session)
        end
    end
})
vim.api.nvim_create_autocmd({ "QuitPre", "ExitPre" }, {
    callback = function()
        if not session_ready then return end
        local dir = vim.fn.getcwd()
        local session = dirToSessionName(dir)
        session = vim.fn.stdpath('data') .. "/nv_sessions/" .. session .. ".vim"
        vim.cmd("mks! " .. session)
    end
})
