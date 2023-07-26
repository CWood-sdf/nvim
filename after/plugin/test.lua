function Test()
    local output = vim.api.nvim_command_output("Copilot status")
    if (output:find("Not logged in")) then
        print("Not logged in")
    elseif (output:find("Enabled")) then
        print("Enabled")
    elseif (output:find("Disabled")) then
        print("Disabled")
    else
        print("Unknown")
    end
    for line in output:gmatch("[^\r\n]+") do
        print("yo " .. line)
    end
end
