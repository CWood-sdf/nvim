if jit.os ~= "Windows" then
    local wk = require("stuff.wkutils")
    local opts = { buffer = vim.api.nvim_get_current_buf(), noremap = false }
    return function()
        wk.makeGroup("n", "<leader>A", "[A]rduino", function(remap)
            remap("c", "[C]ompile",
                function()
                    vim.cmd("ArduinoVerify")
                end, opts)
            remap("u", "[U]pload",
                function()
                    vim.cmd("ArduinoUpload")
                end, opts)
            remap("s", "[S]erial",
                function()
                    vim.cmd("ArduinoSerial")
                end, opts)
            remap("i", "[I]nfo",
                function()
                    vim.cmd("ArduinoInfo")
                end, opts)
            remap("d", "[D]ebug {upload and serial}",
                function()
                    vim.cmd("ArduinoUploadAndSerial")
                end, opts)
            remap("a", "[A]ttach",
                function()
                    vim.cmd("ArduinoAttach")
                end, opts)
        end)
        wk.makeGroup("n", "<leader>Ac", "[C]hoose", function(remap)
            remap("b", "[B]oard",
                function()
                    vim.cmd("ArduinoChooseBoard")
                end, opts)
            remap("p", "[P]ort",
                function()
                    vim.cmd("ArduinoChoosePort")
                end, opts)
            remap("r", "P[r]ogrammer",
                function()
                    vim.cmd("ArduinoChooseProgrammer")
                end, opts)
        end)
        wk.writeBuf()
    end
end
return function() print("windows") end 
