---@param str string
---@return string
local function dirToSessionName(str)
    str = str:sub(2, #str)
    local s, _ = str:gsub('/', '__')
    -- s, _ = s:gsub('%\\.', '##')
    return s
end

-- vim.opt.ssop:append("globals")
local session_ready = false
vim.api.nvim_create_user_command("SessionSource", function()
    local dir = vim.fn.getcwd()
    local session = dirToSessionName(dir)
    session = vim.fn.stdpath('data') .. "/nv_sessions/" .. session .. ".vim"
    -- print(vim.fn.filereadable(session))
    session_ready = true
    local isfile = vim.fn.isdirectory(vim.fn.argv()[1] or "") == 0
    if vim.fn.filereadable(session) ~= 0 and (not isfile or vim.fn.argc() == 0) then
        -- vim.defer_fn(function()
        vim.cmd("so " .. session)
        -- vim.defer_fn(function()
        --     vim.cmd("set signcolumn=yes")
        -- end, 10)
        -- end, 100)
    elseif (not isfile or vim.fn.argc() == 0) then
        session_ready = true
        -- vim.defer_fn(function()
        vim.cmd("Oil .")
        -- end, 100)
        -- vim.cmd("mks " .. session)
    else
        print("Skipping session because opened to file")
    end
end, {})
vim.api.nvim_create_autocmd({ "DirChanged", "QuitPre", "ExitPre", "BufEnter" }, {
    callback = function()
        if not session_ready then return end
        local dir = vim.fn.getcwd()
        local session = dirToSessionName(dir)
        if #vim.api.nvim_list_wins() == 1 and #vim.api.nvim_list_tabpages() == 1 then
            vim.cmd("SessionWipe")
            session_ready = true
            return
        end
        session = vim.fn.stdpath('data') .. "/nv_sessions/" .. session .. ".vim"
        vim.cmd("mks! " .. session)
    end
})

-- vim.api.nvim_create_autocmd({ "SessionLoadPost" }, {
--     callback = function()
--         vim.defer_fn(function()
--             for _, win in ipairs(vim.api.nvim_list_wins()) do
--                 vim.api.nvim_set_option_value("signcolumn", "yes", {
--                     win = win
--                 })
--             end
--         end, 100)
--     end
-- })

vim.api.nvim_create_user_command("SessionWipe", function()
    local dir = vim.fn.getcwd()
    local session = dirToSessionName(dir)
    session = vim.fn.stdpath('data') .. "/nv_sessions/" .. session .. ".vim"
    os.remove(session)
    session_ready = false
end, {

})
