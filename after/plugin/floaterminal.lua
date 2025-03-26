Floaterminal = {
    win = -1,
    buf = -1,
    bufs = {},
    names = {},
    index = 1,
    len = 0
}

local ct = require("cmdTree")

local function updateWinline(win)
    if not vim.api.nvim_win_is_valid(win) then
        return
    end
    local openBufs = 0
    local tabline = ""
    for i = 1, Floaterminal.len do
        local v = Floaterminal.bufs[i]
        if v ~= nil then
            openBufs = openBufs + 1
            if i == Floaterminal.index then
                tabline = tabline .. "%#TablineSel#"
            else
                tabline = tabline .. "%#Tabline#"
            end
            tabline = tabline .. "  " .. i
            if Floaterminal.names[i] ~= nil and #Floaterminal.names[i] ~= 0 then
                tabline = tabline .. " - " .. Floaterminal.names[i]
            end
            tabline = tabline .. "  "
        end
    end
    tabline = tabline .. "%#Tabline#"
    if openBufs > 1 then
        vim.api.nvim_set_option_value("winbar", tabline, { win = win })
    else
        vim.api.nvim_set_option_value("winbar", "", { win = win })
    end
end

---@type CmdTree.CmdTree
local tree = {
    Floaterminal = {
        rename = {
            ct.positionalParam("index", true),
            ct.positionalParam("name", true),
            _callback = function(args)
                local index = tonumber((args.params[1] or {})[1] or "") or 1
                local name = args.params[2][1]
                if name:sub(1, 1) == '"' and name:sub(#name, #name) == '"' then
                    name = name:sub(2, #name - 1)
                end
                Floaterminal.names[index] = name
                updateWinline(Floaterminal.win)
            end,
        },
        toggle = {
            ct.positionalParam("index", false),
            _callback = function(args)
                local index = tonumber((args.params[1] or {})[1] or "")
                index = index or Floaterminal.index
                if Floaterminal.bufs[index] == nil then
                    vim.cmd("Floaterminal newBufAt " .. index)
                end
                local changing = Floaterminal.index ~= index
                Floaterminal.index = index
                local buf = Floaterminal.bufs[Floaterminal.index]
                local open = true
                if not vim.api.nvim_win_is_valid(Floaterminal.win) then
                    Floaterminal.win = vim.api.nvim_open_win(buf, true, {
                        relative = "editor",
                        style = "minimal",
                        row = math.floor(vim.o.lines * 0.1),
                        col = math.floor(vim.o.columns * 0.1),
                        width = math.floor(vim.o.columns * 0.8),
                        height = math.floor(vim.o.lines * 0.8),
                        border = "rounded",
                    })
                    -- vim.api.nvim_set_option_value("number", true, { win = term.win })
                    -- vim.api.nvim_set_option_value("relativenumber", true, { win = term.win })
                    vim.api.nvim_set_option_value("signcolumn", "no", { win = Floaterminal.win })
                    vim.cmd.startinsert()
                elseif changing then
                    vim.api.nvim_win_set_buf(Floaterminal.win, buf)
                elseif vim.api.nvim_get_current_win() == Floaterminal.win then
                    vim.api.nvim_win_hide(Floaterminal.win)
                    open = false
                else
                    vim.api.nvim_set_current_win(Floaterminal.win)
                end
                if vim.bo[buf].buftype ~= "terminal" and open then
                    vim.cmd.term()
                end
                if open then
                    vim.api.nvim_set_option_value("signcolumn", "no", { win = Floaterminal.win })
                    updateWinline(Floaterminal.win)
                    vim.cmd.startinsert()
                end
            end,
        },
        newBufAt = {
            ct.positionalParam("index", true),
            _callback = function(args)
                local index = tonumber(args.params[1][1])
                if index == nil then
                    vim.notify("Given bad index value in Floaterminal newBufAt\n")
                    return
                end
                local buf = vim.api.nvim_create_buf(false, true)
                if Floaterminal.bufs[index] ~= nil then
                    vim.cmd("bw! " .. Floaterminal.bufs[index])
                end
                Floaterminal.bufs[index] = buf
                Floaterminal.len = math.max(index, Floaterminal.len)
                updateWinline(Floaterminal.win)
            end,
        },
        remove = {
            ct.positionalParam("index", true),
            _callback = function(args)
                local index = tonumber(args.params[1][1])
                if index == nil then
                    vim.notify("Given bad index value in Floaterminal remove\n")
                    return
                end
                if Floaterminal.bufs[index] ~= nil then
                    vim.cmd("bw! " .. Floaterminal.bufs[index])
                end
                Floaterminal.bufs[index] = nil
                updateWinline(Floaterminal.win)
            end,
        },
        next = {
            _callback = function()
                local startIndex = Floaterminal.index
                Floaterminal.index = Floaterminal.index + 1
                while Floaterminal.bufs[Floaterminal.index] == nil do
                    if Floaterminal.index == startIndex then
                        break
                    end
                    if Floaterminal.index > Floaterminal.len then
                        Floaterminal.index = 1
                    else
                        Floaterminal.index = Floaterminal.index + 1
                    end
                end
                if vim.api.nvim_win_is_valid(Floaterminal.win) then
                    local index = Floaterminal.index
                    Floaterminal.index = startIndex
                    vim.cmd("Floaterminal toggle " .. index)
                end
            end
        },
        prev = {
            _callback = function()
                local startIndex = Floaterminal.index
                Floaterminal.index = Floaterminal.index - 1
                while Floaterminal.bufs[Floaterminal.index] == nil do
                    if Floaterminal.index == startIndex then
                        break
                    end
                    if Floaterminal.index < 1 then
                        Floaterminal.index = Floaterminal.len
                    else
                        Floaterminal.index = Floaterminal.index - 1
                    end
                end
                if vim.api.nvim_win_is_valid(Floaterminal.win) then
                    local index = Floaterminal.index
                    Floaterminal.index = startIndex
                    vim.cmd("Floaterminal toggle " .. index)
                end
            end
        },
    },
}

ct.createCmd(tree)
