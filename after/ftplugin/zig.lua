local uv = vim.uv

local ev = nil

local lastDiags = {}

local cmd = false

local function trackFile(file)
    -- local relativeDir = vim.fn.fnamemodify(file, ":h")
    if ev == nil then
        ev = uv.new_fs_event()
        if ev == nil then
            print("no ev created :(")
            return
        end

        uv.fs_event_start(ev, file, {},
            vim.schedule_wrap(function()
                vim.fn.setqflist({})
                vim.cmd("cgetfile " .. file)
                local ns = vim.api.nvim_create_namespace("ayyo")

                local qflist = vim.fn.getqflist()

                -- for _, v in ipairs(qflist) do
                --     v.bufnr = vim.api.nvim_buf_from
                -- end

                local diags = vim.diagnostic.fromqflist(qflist)

                local levels = {
                    note = vim.diagnostic.severity.HINT,
                    error = vim.diagnostic.severity.ERROR,
                }

                for buf, _ in pairs(lastDiags) do
                    lastDiags[buf] = {}
                end

                for _, diag in ipairs(diags) do
                    local msg = diag.message
                    for zigname, level in pairs(levels) do
                        if msg:sub(2, #zigname + 1) == zigname then
                            diag.severity = level
                            diag.message = msg:sub(#zigname + 4)
                            break
                        end
                    end
                    lastDiags[diag.bufnr] = lastDiags[diag.bufnr] or {}

                    table.insert(lastDiags[diag.bufnr], diag)
                end

                for buf, diag in pairs(lastDiags) do
                    vim.diagnostic.set(ns, buf, diag, {})
                end
            end))
    end
end

trackFile("zig_errors.txt")



if not cmd then
    vim.api.nvim_create_user_command("ZigCancelAutoDiagnostic", function()
        if ev ~= nil then
            uv.fs_event_stop(ev)
            ev = nil
        end
    end, {})
    vim.api.nvim_create_user_command("ZigStartAutoDiagnostic", function(opts)
        if ev ~= nil then
            uv.fs_event_stop(ev)
            ev = nil
        end
        trackFile(opts.fargs[1])
    end, {
        nargs = 1,
    })
end
