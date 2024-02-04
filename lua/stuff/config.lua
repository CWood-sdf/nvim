local M = {}

local flags = {}
local callbacks = {}

local function filterCompletion(working, items)
    local newItems = {}
    for _, item in ipairs(items) do
        if item:sub(1, #working) == working then
            table.insert(newItems, item)
        end
    end
    return newItems
end

local cmdTree = {
    Config = {
        set = {},
        toggle = {},
        get = {},
    },
}

local function initCmd()
    vim.api.nvim_create_user_command("Config", function(opts)
        if #opts.fargs == 0 then
            print("No arguments given")
            return
        end
        if opts.fargs[1] == "set" then
            local flag = ""
            for i = 2, #opts.fargs - 1 do
                flag = flag .. opts.fargs[i]
                flag = flag .. "."
            end
            flag = flag:sub(1, #flag - 1)
            local value = opts.fargs[#opts.fargs] == "true"
            M.set(flag, value)
        end
        if opts.fargs[1] == "toggle" then
            local flag = ""
            for i = 2, #opts.fargs do
                flag = flag .. opts.fargs[i]
                flag = flag .. "."
            end
            flag = flag:sub(1, #flag - 1)
            M.toggle(flag)
        end
        if opts.fargs[1] == "get" then
            local flag = ""
            for i = 2, #opts.fargs - 1 do
                flag = flag .. opts.fargs[i]
                flag = flag .. "."
            end
            flag = flag:sub(1, #flag - 1)
            print(M.get(flag))
        end
    end, {
        nargs = "*",
        complete = function(working, current, _)
            cmdTree.Config.set = flags
            cmdTree.Config.toggle = flags
            cmdTree.Config.get = flags
            local tempCmds = cmdTree
            local i = 1
            local cmdStr = ""
            while i <= #current do
                local c = current:sub(i, i)
                if c == " " then
                    if tempCmds[cmdStr] ~= nil then
                        tempCmds = tempCmds[cmdStr]
                        if tempCmds == nil then
                            return {}
                        end
                        cmdStr = ""
                    else
                        return {}
                    end
                else
                    cmdStr = cmdStr .. c
                end
                i = i + 1
            end
            if type(tempCmds) ~= "table" then
                return {}
            end
            if tempCmds ~= nil then
                local ret = {}
                for k, _ in pairs(tempCmds) do
                    table.insert(ret, k)
                end


                return filterCompletion(working, ret)
            end
            return {}
        end,

    })
end

function M.setup()
    initCmd()
end

function M.addFlag(flag)
    local tempString = ""
    local i = 1
    local flagObj = flags
    local callbackObj = callbacks
    while i <= #flag do
        local char = flag:sub(i, i)
        if char == "." then
            if flagObj[tempString] == nil then
                flagObj[tempString] = {}
                callbackObj[tempString] = {}
            end
            flagObj = flagObj[tempString]
            callbackObj = callbackObj[tempString]
            tempString = ""
        else
            tempString = tempString .. char
        end
        i = i + 1
    end
    if tempString ~= "" then
        flagObj[tempString] = true
        callbackObj[tempString] = {}
    end
end

function M.addFlagSet(flagSet)
    local tempString = ""
    local i = 1
    local flagObj = flags
    local callbackObj = callbacks
    while i <= #flagSet do
        local char = flagSet:sub(i, i)
        if char == "." then
            if flagObj[tempString] == nil then
                flagObj[tempString] = {}
                callbackObj[tempString] = {}
            end
            flagObj = flagObj[tempString]
            callbackObj = callbackObj[tempString]
            tempString = ""
        else
            tempString = tempString .. char
        end
        i = i + 1
    end
    if tempString ~= "" then
        flagObj[tempString] = {}
        callbackObj[tempString] = {}
    end
end

function M.set(flag, value)
    local tempString = ""
    local i = 1
    local flagObj = flags
    local callbackObj = callbacks
    while i <= #flag do
        local char = flag:sub(i, i)
        if char == "." then
            if flagObj[tempString] == nil then
                flagObj[tempString] = {}
                callbackObj[tempString] = {}
            end
            flagObj = flagObj[tempString]
            callbackObj = callbackObj[tempString]
            tempString = ""
        else
            tempString = tempString .. char
        end
        i = i + 1
    end
    if tempString ~= "" then
        flagObj[tempString] = value
        for _, callback in ipairs(callbackObj[tempString]) do
            callback(value)
        end
    end
end

function M.toggle(flag)
    local tempString = ""
    local i = 1
    local flagObj = flags
    local callbackObj = callbacks
    while i <= #flag do
        local char = flag:sub(i, i)
        if char == "." then
            if flagObj[tempString] == nil then
                flagObj[tempString] = {}
                callbackObj[tempString] = {}
            end
            flagObj = flagObj[tempString]
            callbackObj = callbackObj[tempString]
            tempString = ""
        else
            tempString = tempString .. char
        end
        i = i + 1
    end
    if type(flagObj[tempString]) == "table" then
        return
    end
    if tempString ~= "" then
        flagObj[tempString] = not flagObj[tempString]
        for _, callback in ipairs(callbackObj[tempString]) do
            callback(flagObj[tempString])
        end
    end
end

function M.addCallback(flag, fn)
    local tempString = ""
    local i = 1
    local flagObj = flags
    local callbackObj = callbacks
    while i <= #flag do
        local char = flag:sub(i, i)
        if char == "." then
            if flagObj[tempString] == nil then
                flagObj[tempString] = {}
                callbackObj[tempString] = {}
            end
            flagObj = flagObj[tempString]
            callbackObj = callbackObj[tempString]
            tempString = ""
        else
            tempString = tempString .. char
        end
        i = i + 1
    end
    if tempString ~= "" then
        table.insert(callbackObj[tempString], fn)
    end
end

function M.get(flag)
    local tempString = ""
    local i = 1
    local flagObj = flags
    while i <= #flag do
        local char = flag:sub(i, i)
        if char == "." then
            if flagObj[tempString] == nil then
                flagObj[tempString] = {}
            end
            flagObj = flagObj[tempString]
            tempString = ""
        else
            tempString = tempString .. char
        end
        i = i + 1
    end
    if tempString ~= "" then
        if flagObj[tempString] == nil then
            flagObj[tempString] = true
        end
        return flagObj[tempString]
    end
    return true
end

function M.getFn(flag)
    return function()
        return M.get(flag)
    end
end

return M
