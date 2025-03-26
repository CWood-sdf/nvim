local function canvasImport(_, success)
    local output = ""
    vim.fn.jobstart({ "node", os.getenv("HOME") .. "/canvas-api/index.js" }, {
        cwd = os.getenv("HOME") .. "/canvas-api",
        on_exit = function()
            -- print(vim.inspect(code))
            -- if code ~= 0 then
            --     fail()
            -- else
            success()
            -- end
        end,
        on_stderr = function() end,
        on_stdout = function(e, d)
            for _, v in ipairs(d) do
                output = output .. v
            end
            if string.find(output, "]") then
                ---@type table<string, {name: string, due: integer, course: string}>
                local data = vim.json.decode(output) or {}
                for _, event in ipairs(require("calendar").readData().assignments) do
                    local stillExists = false
                    if event.source ~= "canvas" then
                        stillExists = true
                    end
                    for _, newEvent in ipairs(data) do
                        if newEvent.name == event.title then
                            stillExists = true
                            break
                        end
                    end
                    if not stillExists then
                        require("calendar").markDone(event.title)
                    end
                end

                for _, event in ipairs(data) do
                    ---@type CalendarAssignment
                    e = {
                        type = "assignment",
                        title = event.name,
                        due = event.due,
                        warnTime = "1d",
                        description = event.course or "",
                        source = "canvas",
                    }
                    pcall(function()
                        require("calendar").addAssignment(e)
                    end)
                end
                output = ""
            end
        end,
    })
end

local function waImport(_, success)
    local output = ""
    vim.fn.jobstart({ "node", os.getenv("HOME") .. "/webassign-api/index.js" }, {
        cwd = os.getenv("HOME") .. "/webassign-api",
        on_exit = function()
            -- print(vim.inspect(code))
            -- if code ~= 0 then
            --     fail()
            -- else
            success()
            -- end
        end,
        on_stderr = function() end,
        on_stdout = function(e, d)
            for _, v in ipairs(d) do
                output = output .. v
            end
            if string.find(output, "]") then
                -- print("found")
                ---@type table<string, {name: string, due: integer, course: string}>
                local data = vim.json.decode(output) or {}
                for _, event in ipairs(require("calendar").readData().assignments) do
                    local stillExists = false
                    if event.source ~= "webassign" then
                        stillExists = true
                    end
                    for _, newEvent in ipairs(data) do
                        if newEvent.name == event.title then
                            stillExists = true
                            break
                        end
                    end
                    if not stillExists then
                        require("calendar").markDone(event.title)
                    end
                end

                for _, event in ipairs(data) do
                    ---@type CalendarAssignment
                    e = {
                        type = "assignment",
                        title = event.name,
                        due = event.due,
                        description = event.course or "",
                        warnTime = "1d",
                        source = "webassign",
                    }
                    require("calendar").addAssignment(e)
                end
                output = ""
            end
        end,
    })
end

local function gsImport(_, success)
    local output = ""
    vim.fn.jobstart({ "node", os.getenv("HOME") .. "/gradescope-api/index.js" }, {
        cwd = os.getenv("HOME") .. "/gradescope-api",
        on_exit = function()
            -- print(vim.inspect(code))
            -- if code ~= 0 then
            --     fail()
            -- else
            success()
            -- end
        end,
        on_stderr = function()
            -- print(vim.inspect(e))
        end,
        on_stdout = function(_, d)
            for _, v in ipairs(d) do
                output = output .. v
            end
            if string.find(output, "]") then
                -- print("found")
                ---@type table<string, {name: string, due: integer, course: string}>
                local data = vim.json.decode(output) or {}
                for _, event in ipairs(require("calendar").readData().assignments) do
                    if event.done then
                        goto continue
                    end
                    local stillExists = false
                    if event.source ~= "gradescope" then
                        stillExists = true
                    end
                    for _, newEvent in ipairs(data) do
                        if newEvent.name == event.title then
                            stillExists = true
                            break
                        end
                    end
                    if not stillExists then
                        require("calendar").markDone(event.title)
                    end
                    ::continue::
                end

                for _, event in ipairs(data) do
                    ---@type CalendarAssignment
                    local e = {
                        type = "assignment",
                        title = event.name,
                        due = event.due,
                        warnTime = "1d",
                        description = event.course or "",
                        source = "gradescope",
                    }
                    require("calendar").addAssignment(e)
                end
                output = ""
            end
        end,
    })
end

local function calendarConfig()
    require("calendar").setup({
        import = {
            {
                id = "canvas",
                runFrequency = "1h",
                fn = canvasImport,
            },
            {
                id = "webassign",
                runFrequency = "1h",
                fn = waImport,
            },
            {
                id = "gradescope",
                runFrequency = "1h",
                fn = gsImport,
            },
            {
                id = "test",
                runFrequency = "365d",
                fn = function(_, success)
                    print("Running test")
                    require("calendar").addAssignment({
                        source = "test",
                        title = "Test " .. os.date("%A"),
                        due = vim.fn.strptime("%Y-%m-%d %H:%M:%S", vim.fn.strftime("%Y-%m-%d") .. " 23:59:00"),
                        warnTime = "1d",
                        description = "Test " .. os.date("%A"),
                        type = "assignment",
                    })
                    -- require('calendar').inputAssignment()
                    success()
                end,
            },
            {
                id = "pray",
                runFrequency = "c0 0 4 * * *",
                fn = function(_, success)
                    -- print("Running pray")
                    require("calendar").addAssignment({
                        source = "pray",
                        title = "Pray " .. os.date("%A"),
                        due = vim.fn.strptime("%Y-%m-%d %H:%M:%S", vim.fn.strftime("%Y-%m-%d") .. " 23:59:00") +
                            60 * 2 * 60,
                        warnTime = "1d",
                        description = "Pray " .. os.date("%A"),
                        type = "assignment",
                    })
                    success()
                end,
            },
        },
    })
end
return {
    "CWood-sdf/calendar",
    lazy = false,
    config = calendarConfig,
    dev = require("stuff.isdev")("calendar"),
    build = "make",
    dependencies = {
        "CWood-sdf/cmdTree.nvim",
    },
}
