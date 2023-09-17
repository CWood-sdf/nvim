local a = require 'plenary.async'

local tx, rx = a.control.channel.oneshot()

local sender, receiver = a.control.channel.mpsc()

a.run(function()
    -- vim.cmd("!ping localhost -c 5")
    os.execute("sleep 1")
    print("sdfsdf")
    -- sender.send("hello")
end)
-- local ret = rx()
-- print(ret)

print("sdf")
-- for _ = 1, 4 do
--     local ret = receiver.recv()
--     print(ret)
-- end
