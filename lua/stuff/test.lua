local t = vim.loop.hrtime()


local arr = {}
local x = 0

while x < 46 do
    local sub = {}
    local y = 0
    while y < 71 do
        sub[y + 1] = "a"
        y = y + 1
    end
    arr[x + 1] = sub
    x = x + 1
end
print(arr[45][70])

local t2 = vim.loop.hrtime()
print((t2 - t) / 1e6, "ms")
