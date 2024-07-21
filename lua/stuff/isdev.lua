return function(path)
    path = os.getenv("HOME") .. "/projects/" .. path .. "/"
    local ok, _, code = os.rename(path, path)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    if ok == nil then
        return false
    end
    return ok
end
