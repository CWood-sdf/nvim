local M = {}

local flags = {}
local callbacks = {}
local ct = require('cmdTree')

local getFlag = ct.repeatParams(function(args)
    if args.params[1] == nil then
        local ret = {}
        for k, _ in pairs(flags) do
            table.insert(ret, k)
        end
        return ret
    end
    local t = flags
    for _, v in ipairs(args.params[1]) do
        t = t[v]
        if type(t) ~= "table" then
            return nil
        end
    end
    if type(t) ~= "table" then
        return nil
    end
    local ret = {}
    for k, _ in pairs(t) do
        table.insert(ret, k)
    end
    return ret
end)

local cmdTree = {
    Config = {
        set = {
            _callback = function(args)
                local str = ""
                for _, v in ipairs(args.params[1]) do
                    str = str .. v
                    str = str .. "."
                end
                str = str:sub(1, #str - 1)
                M.set(str, args.params[2] == "true")
            end,
            getFlag,
            ct.requiredParams(function()
                return { "true", "false" }
            end),

        },
        toggle = {
            _callback = function(args)
                local str = ""
                for _, v in ipairs(args.params[1]) do
                    str = str .. v
                    str = str .. "."
                end
                str = str:sub(1, #str - 1)
                M.toggle(str)
            end,
            getFlag,
        },
        get = {
            _callback = function(args)
                local str = ""
                for _, v in ipairs(args.params[1]) do
                    str = str .. v
                    str = str .. "."
                end
                str = str:sub(1, #str - 1)
                print(M.get(str))
            end,
            getFlag,
        },
    },
}

local function initCmd()
    ct.createCmd(cmdTree, {

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
            if callbackObj[tempString] == nil then
                callbackObj[tempString] = {}
            end
            if flagObj[tempString] == nil then
                flagObj[tempString] = {}
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
        if flagObj[tempString] == nil then
            flagObj[tempString] = true
            callbackObj[tempString] = {}
        end
        return flagObj[tempString]
    end
    return true
end

function M.has(flag)
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
        return flagObj[tempString] ~= nil
    end
    return true
end

function M.getFn(flag)
    if not M.has(flag) then
        M.addFlag(flag)
    end
    local val = M.get(flag)
    M.addCallback(flag, function(newVal)
        val = newVal
    end)
    return function()
        return val
    end
end

return M
