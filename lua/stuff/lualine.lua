-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
-- CWood-sdf additions: Copilot status, formatting name, debug name
local lualine = require("lualine")
local branch = ""
--needed bc lualine with bold in gui is rlly ugly
local boldSetting = ""
vim.defer_fn(function()
    boldSetting = (function()
        if vim.fn.exists("GuiFont") == 1 then
            return "bold"
        end
        return "bold"
    end)()
end, 500)
-- Color table for highlights
-- stylua: ignore
local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}
local function getModeColor()
    -- auto change color according to neovims mode
    local mode_color = {
        n = colors.red,
        i = colors.green,
        v = colors.blue,
        [""] = colors.blue,
        V = colors.blue,
        [""] = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.green,
    }
    return { bg = mode_color[vim.fn.mode()], fg = "#000000" }
end

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- Config
local config = {
    globalstatus = true,
    options = {
        globalstatus = true,
        -- Disable sections and component separators
        component_separators = "",
        section_separators = "",
        theme = "tokyonight",
    },
    sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

-- ins_left({
--     function()
--         return "▊"
--     end,
--     color = getModeColor,
--     padding = { left = 0, right = 0 }, -- We don't need space before this
-- })
-- sdf
ins_left({
    "filename",
    color = getModeColor,
    cond = conditions.buffer_not_empty,
    -- color = { fg = "#aaaaff", gui = boldSetting },
})

ins_left({ "progress" })
ins_left({ "location" })

ins_left({
    "o:encoding", -- option component same as &encoding in viml
    cond = conditions.hide_in_width,
    color = { fg = colors.green, gui = boldSetting },
})

ins_left({
    "fileformat",
    fmt = string.upper,
    icons_enabled = true,
    color = { fg = colors.green, gui = boldSetting },
})

ins_left({
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " " },
    diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.cyan },
    },
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
    function()
        return "%="
    end,
})
local hasEnteredFile = false
local auGroup = vim.api.nvim_create_augroup("Lualine", {})
vim.api.nvim_create_autocmd({ "BufRead" }, {
    pattern = "*",
    group = auGroup,
    callback = function()
        hasEnteredFile = true
        vim.api.nvim_clear_autocmds({
            group = auGroup,
        })
    end,
})
local dapSetup = false
local dap_save_path = vim.fn.stdpath("data") .. "/dapft.txt"
ins_left({
    -- Lsp server name .
    function()
        local hasLsp = false
        local hasFmt = false
        local hasDbg = false
        local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
        if buf_ft == "" then
            return ""
        end
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
            hasLsp = false
        end
        for _, client in ipairs(clients) do
            ---@diagnostic disable-next-line: undefined-field
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                hasLsp = true
                if client.server_capabilities.documentFormattingProvider then
                    hasFmt = true
                end
            end
        end
        -- get dem formatters
        local formatters = require("conform").list_formatters(vim.api.nvim_get_current_buf())
        for _, formatter in ipairs(formatters) do
            if formatter.available then
                hasFmt = true
            end
        end

        -- this is for caching dap status
        local dapFile = io.open(dap_save_path, "r")
        if dapFile == nil then
            local f = io.open(dap_save_path, "w")
            f = f or {}
            f:write("")
            f:close()
            dapFile = io.open(dap_save_path, "r") or {}
        end
        local dapTable = {}
        -- read dapFile line by line into dapTable
        local dapStr = dapFile:read("*l")
        while dapStr ~= nil do
            dapTable[dapStr] = true
            dapStr = dapFile:read("*l")
        end
        -- we dont want to setup dap bc it takes forever
        if not dapSetup then
            for _, v in pairs(require("lazy").plugins()) do
                if v[1] == "mfussenegger/nvim-dap" and v._.loaded ~= nil then
                    dapSetup = true
                end
            end
        end
        if dapSetup then
            local dap = require("dap")
            local has_dap = dap.configurations[vim.bo.filetype] ~= nil
            if has_dap then
                hasDbg = true
            end
            if hasDbg and dapTable[vim.bo.filetype] == nil then
                dapTable[vim.bo.filetype] = true
                local file = io.open(dap_save_path, "w")
                local str = ""
                for k, _ in pairs(dapTable) do
                    str = str .. k .. "\n"
                end
                file:write(str)
            end
        else
            hasDbg = dapTable[vim.bo.filetype] == true
        end
        local ret = ""
        -- just add the signs
        if hasLsp then
            ret = " "
        end
        if hasFmt then
            ret = ret .. " "
        end
        if hasDbg then
            ret = ret .. " "
        end
        return ret
    end,
    color = { fg = "#ffffff", gui = boldSetting },
})

-- git pull/push list
local lastFetch = 0
local canCheck = false
local canGetChangeCount = false
local changes = {
    out = 0,
    in_ = 0,
}
ins_right({
    function()
        if vim.loop.hrtime() - lastFetch > 1000000000 then
            lastFetch = vim.loop.hrtime()
            vim.fn.jobstart("git fetch", {
                on_exit = function()
                    canCheck = true
                end,
            })
        end
        if canCheck and branch ~= "" then
            canCheck = false
            vim.fn.jobstart("git rev-list --left-right --count origin/" .. branch .. "..." .. branch, {
                on_stdout = function(_, str)
                    if str[1] == "" then
                        return
                    end
                    -- print(str[1])
                    local in_, out = str[1]:match("(%d+)%s+(%d+)")
                    changes.out = out * 1
                    changes.in_ = in_ * 1
                end,
                on_stderr = function(_, str)
                    if str[1] == "" then
                        return
                    end
                    canGetChangeCount = true
                end,
            })
        end
        if canGetChangeCount then
            canGetChangeCount = false
            vim.fn.jobstart("git rev-list --left-right --count @{upstream}...HEAD", {
                on_stdout = function(_, str)
                    if str[1] == "" then
                        return
                    end
                    local out = str[1]:match("(%d+)")
                    -- print(str[1])
                    changes.out = out * 1
                    changes.in_ = 0
                end,
                on_exit = function() end,
            })
        end
        if changes.out == 0 and changes.in_ == 0 then
            return ""
        end
        -- print(changes.out, changes.in_)
        local up = " "
        local down = " "
        if changes.out == 0 then
            return changes.in_ .. down
        end
        if changes.in_ == 0 then
            return changes.out .. up
        end
        return changes.out .. up .. " " .. changes.in_ .. down
    end,
    color = { fg = "#5ee4ff" },
})
-- Lazy sync status
local hasChecked = false
ins_right({
    function()
        -- only check at start of program
        if not hasChecked then
            require("lazy.manage.checker").check()
            hasChecked = true
        end
        if require("lazy.status").has_updates() then
            return require("lazy.status").updates()
        end
        return ""
    end,
    color = { fg = "#5EE4FF" },
})

local startTime = nil
-- Add components to right sections
local hasInternet = false
local lastInternetCheck = 0
local copilotSetup = false
ins_right({
    function()
        if not hasInternet or (vim.loop.hrtime() - lastInternetCheck) > 10000000000 then
            -- annoyingly, :Copilot status freezes up the entire ui indefinitely if there's no internet
            local ping = "ping google.com"
            if jit.os:find("Windows") == nil then
                ping = ping .. " -c"
            else
                ping = ping .. " -n"
            end
            ping = ping .. " 1"
            vim.fn.jobstart(ping, {
                on_exit = function(_, code)
                    if code == 0 then
                        hasInternet = true
                    else
                        hasInternet = false
                    end
                end,
            })
        end
        if not hasInternet then
            return "󰖪"
        end
        if not copilotSetup then
            vim.cmd("Copilot enable")
            copilotSetup = true
        end
        if hasEnteredFile == false then
            return ""
        elseif startTime == nil then
            startTime = vim.loop.hrtime()
            return ""
        end
        if vim.loop.hrtime() - startTime > 100000000 then
            local output = vim.api.nvim_exec2("Copilot status", { output = true }).output

            if output:find("Not logged in") then
                return ""
            elseif output:find("Enabled") then
                return ""
            elseif output:find("Disabled") then
                return ""
            else
                return ""
            end
        else
            return "󰔟"
        end
    end,
})
ins_right({
    "filetype",
    icon_only = false,
    icon = {
        align = "left",
    },
})

ins_right({
    "diff",
    -- Is it me or the symbol for modified us really weird
    symbols = { added = " ", modified = " ", removed = " " },
    diff_color = {
        added = { fg = colors.green },
        modified = { fg = "#ffbb00" },
        removed = { fg = colors.red },
    },
})

local branchRunning = false
ins_right({
    function()
        if not branchRunning then
            branchRunning = true
            vim.fn.jobstart("git branch --show-current", {
                on_stdout = function(_, str)
                    if str[1] ~= "" then
                        branch = "" .. str[1]
                    end
                end,
                on_exit = function()
                    branchRunning = false
                end,
            })
            --
        end
        return branch
    end,
    icon = "",
    color = getModeColor,
})

-- ins_right({
--     function()
--         return "▊"
--     end,
--     color = getModeColor,
--     padding = { left = 1 },
-- })

-- Now don't forget to initialize lualine
lualine.setup(config)
