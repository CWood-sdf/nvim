-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
-- CWood-sdf additions: lotsa stuff
local branch = ""
--needed bc lualine with bold in gui is rlly ugly
local boldSetting = ""
local Config = require("stuff.config")
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
        local start = vim.loop.hrtime()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        local time = vim.loop.hrtime() - start
        print("Time to check git workspace: " .. time / 1e6 .. "ms")
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
local fname = Config.getFn("lualine.filename")
ins_left({
    "filename",
    color = getModeColor,
    events = { "ModeChanged" },
    cond = function()
        return conditions.buffer_not_empty() and fname()
    end,
    -- color = { fg = "#aaaaff", gui = boldSetting },
})
Config.addFlag("lualine.perf")
Config.set("lualine.perf", false)
ins_left({
    function()
        -- return ""
        -- local time = require('lazyline').getTimeSpent()
        local time = require("lazyline").getTimeSpent()
        return require("calendar.utils").deltaToLengthStr(time / 1e9) .. "" .. math.ceil((time % 1e9) / 1e6) .. "ms"
    end,
    events = "*",
    -- fmt = string.upper,
    cond = Config.getFn("lualine.perf"),
    color = { fg = colors.green, gui = boldSetting },
})

Config.addFlag("lualine.progress")
Config.set("lualine.progress", false)
ins_left({
    "progress",
    cond = Config.getFn("lualine.progress"),
})
ins_left({
    "location",
    cond = Config.getFn("lualine.location"),
})

local encodingFlag = Config.getFn("lualine.encoding")
ins_left({
    function()
        return vim.opt.encoding:get()
    end,
    cond = function()
        return conditions.hide_in_width() and encodingFlag()
    end,
    color = { fg = colors.green, gui = boldSetting },
    events = { "BufEnter" },
})

ins_left({
    "fileformat",
    icons_enabled = true,
    color = { fg = colors.green, gui = boldSetting },
    cond = Config.getFn("lualine.fileformat"),
})

ins_left({
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " " },
    -- diagnostics_color = {
    --     error = { fg = colors.red },
    --     warn = { fg = colors.yellow },
    --     -- info = { fg =  },
    -- },
    cond = Config.getFn("lualine.diagnostics"),
    fmt = function(s)
        return s .. " "
    end,
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
vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "SpaceportDone",
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
local lspFlag = Config.getFn("lualine.lsp")
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
        local clients = vim.lsp.get_clients({
            bufnr = 0,
        })
        for i = #clients, 1, -1 do
            if clients[i].name == "null-ls" or clients[i].name == "copilot" then
                table.remove(clients, i)
            end
        end
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
                if file == nil then
                    return ""
                end
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
    events = { "BufEnter", "LspAttach", "LspDetach" },
    jobs = {
        {
            events = { "LspDetach" },
            function(render)
                vim.defer_fn(function()
                    render()
                end, 100)
            end,
        },
    },
    color = { fg = "#ffffff", gui = boldSetting },
    cond = function()
        return lspFlag() and hasEnteredFile
    end,
})

-- git pull/push list
-- local lastFetch = 0
-- local canCheck = false
-- local canGetChangeCount = false
local changes = {
    out = 0,
    in_ = 0,
}
local prayFlag = Config.getFn("lualine.calendarPray")
local lastPrayAssignments = 0
ins_right({
    function()
        local amount = lastPrayAssignments
        if amount == 0 then
            return ""
        end
        return " " .. amount
    end,
    jobs = {
        {
            events = { "(1s)" },
            function(render)
                local old           = lastPrayAssignments
                local assignments   = require("calendar").getAssignmentsToWorryAbout()
                assignments         = vim.tbl_filter(function(v) return v.source == "pray" end, assignments)
                lastPrayAssignments = #assignments
                if old ~= lastPrayAssignments then
                    render()
                end
            end,
        },
    },
    color = { fg = "#9e9eeb" },
    cond = function()
        return prayFlag() and #require("calendar").getAssignmentsToWorryAbout() > 0
    end,
    fmt = function(str) return str .. ' ' end,
})
local assignmentsFlag = Config.getFn("lualine.calendarStatus")
local lastAssignments = 0
ins_right({
    function()
        local amount = lastAssignments
        if amount == 0 then
            return ""
        end
        return " " .. amount
    end,
    jobs = {
        {
            events = { "(1s)" },
            function(render)
                local old         = lastAssignments
                local assignments = require("calendar").getAssignmentsToWorryAbout()
                assignments       = vim.tbl_filter(function(v) return v.source ~= "pray" end, assignments)
                lastAssignments   = #assignments
                if old ~= lastAssignments then
                    render()
                end
            end,
        },
    },
    color = { fg = "#5EE4FF" },
    cond = function()
        return assignmentsFlag() and #require("calendar").getAssignmentsToWorryAbout() > 0
    end,
    fmt = function(str) return str .. ' ' end,
})
local lastEvents = 0
ins_right({
    fmt = function(str) return str .. ' ' end,
    function()
        local amount = lastEvents
        if amount == 0 then
            return ""
        end
        return "󱨰 " .. amount
    end,
    jobs = {
        {
            events = { "(1s)" },
            function(render)
                local old = lastEvents
                lastEvents = #require("calendar").getEventsToWorryAbout()
                if old ~= lastEvents then
                    render()
                end
            end,
        },
    },
    color = { fg = "#b880eb" },
    cond = Config.getFn("lualine.calendarEvents"),
})
local gitFlag = Config.getFn("lualine.gitStatus")
ins_right({
    jobs = {
        {
            events = { "(5s)", "DirChanged" },
            function(render)
                vim.fn.jobstart("git fetch", {
                    on_exit = function()
                        if branch ~= "" then
                            local oldOut = changes.out
                            local oldIn = changes.in_
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
                                    local oldOut2 = changes.out
                                    local oldIn2 = changes.in_
                                    vim.fn.jobstart("git rev-list --left-right --count @{upstream}...HEAD", {
                                        on_stdout = function(_, s)
                                            if s[1] == "" then
                                                return
                                            end
                                            local out = s[1]:match("(%d+)")
                                            -- print(str[1])
                                            changes.out = out * 1
                                            changes.in_ = 0
                                        end,
                                        on_exit = function()
                                            if oldOut2 ~= changes.out or oldIn2 ~= changes.in_ then
                                                render()
                                            end
                                        end,
                                    })
                                end,
                                on_exit = function()
                                    if oldOut ~= changes.out or oldIn ~= changes.in_ then
                                        render()
                                    end
                                end,
                            })
                        end
                    end,
                })
            end,
        },
    },
    function()
        if changes.out == 0 and changes.in_ == 0 then
            return ""
        end
        local up = ""
        local down = ""
        if changes.out == 0 then
            return changes.in_ .. down
        end
        if changes.in_ == 0 then
            return changes.out .. up
        end
        return changes.out .. up .. " " .. changes.in_ .. down
    end,
    color = { fg = "#5ee4ff" },
    cond = function()
        return gitFlag()
    end,
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
    events = { "User LazyCheck", "User LazySync" },
    color = { fg = "#5EE4FF" },
    cond = Config.getFn("lualine.lazyStatus"),
})

-- local startTime = nil
-- -- Add components to right sections
-- local hasInternet = false
-- local lastInternetCheck = 0
-- local copilotSetup = false
-- local Copilot = {
-- 	startTime = nil,
-- 	hasInternet = false,
-- 	lastInternetCheck = 0,
-- 	copilotSetup = false,
-- 	cachedReturn = "",
-- }
-- ins_right({
-- 	function()
-- 		if not Copilot.hasInternet then
-- 			return "󰖪"
-- 		end
-- 		if hasEnteredFile == false then
-- 			return ""
-- 		elseif Copilot.startTime == nil then
-- 			Copilot.startTime = vim.loop.hrtime()
-- 			return ""
-- 		end
-- 		return Copilot.cachedReturn
-- 	end,
-- 	jobs = {
-- 		{
-- 			events = { "(1s)" },
-- 			function(render)
-- 				Copilot.lastInternetCheck = vim.loop.hrtime()
-- 				local ping = "ping google.com"
-- 				if jit.os:find("Windows") == nil then
-- 					ping = ping .. " -c"
-- 				else
-- 					ping = ping .. " -n"
-- 				end
-- 				ping = ping .. " 1"
-- 				local old = Copilot.hasInternet
-- 				vim.fn.jobstart(ping, {
-- 					on_exit = function(_, code)
-- 						if code == 0 then
-- 							Copilot.hasInternet = true
-- 						else
-- 							Copilot.hasInternet = false
-- 						end
-- 						if old ~= Copilot.hasInternet then
-- 							render()
-- 						end
-- 					end,
-- 				})
-- 			end,
-- 		},
-- 		{
-- 			events = { "(1s)", "BufEnter" },
-- 			function(render)
-- 				if not Copilot.hasInternet then
-- 					return
-- 				end
-- 				if not Copilot.copilotSetup then
-- 					vim.cmd("Copilot enable")
-- 					Copilot.copilotSetup = true
-- 				end
-- 				Copilot.startTime = vim.loop.hrtime()
-- 				local old = Copilot.cachedReturn
-- 				local output = vim.api.nvim_exec2("Copilot status", { output = true }).output
--
-- 				local ret = ""
-- 				if output:find("Not logged in") then
-- 					ret = ""
-- 				elseif output:find("Enabled") or output:find("Ready") then
-- 					ret = ""
-- 				elseif output:find("Disabled") then
-- 					ret = ""
-- 				else
-- 					ret = ""
-- 				end
-- 				Copilot.cachedReturn = ret
-- 				if old ~= ret then
-- 					render()
-- 				end
-- 			end,
-- 		},
-- 	},
-- 	cond = Config.getFn("lualine.copilot"),
-- })
ins_right({
    "filetype",
    icon_only = false,
    icon = {
        align = "left",
    },
    cond = Config.getFn("lualine.filetype"),
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
    cond = Config.getFn("lualine.diff"),
})

ins_right({
    function()
        if branch == "" then
            return ""
        end
        return " " .. branch
    end,
    events = { "ModeChanged" },
    color = getModeColor,
    cond = Config.getFn("lualine.branch"),
    jobs = {
        {
            function(render)
                vim.fn.jobstart("git branch --show-current", {
                    on_stdout = function(_, str)
                        if str[1] ~= "" then
                            branch = "" .. str[1]
                        end
                    end,
                    on_exit = function()
                        render()
                    end,
                })
            end,
            events = { "DirChanged", "(10s)" },
        },
    },
})
return config
