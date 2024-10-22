if jit.os ~= "Windows" then
    local wk = require("stuff.wkutils")
    wk.makeGroup("n", "<leader>A", "[A]rduino", function(remap)
        remap("c", "[C]ompile", function()
            vim.cmd("ArduinoVerify")
        end)
        remap("u", "[U]pload", function()
            vim.cmd("ArduinoUpload")
        end)
        remap("s", "[S]erial", function()
            vim.cmd("ArduinoSerial")
        end)
        remap("i", "[I]nfo", function()
            vim.cmd("ArduinoInfo")
        end)
        remap("d", "[D]ebug {upload and serial}", function()
            vim.cmd("ArduinoUploadAndSerial")
        end)
        remap("a", "[A]ttach", function()
            vim.cmd("ArduinoAttach")
        end)
    end)
    wk.makeGroup("n", "<leader>Ac", "[C]hoose", function(remap)
        remap("b", "[B]oard", function()
            vim.cmd("ArduinoChooseBoard")
        end)
        remap("p", "[P]ort", function()
            vim.cmd("ArduinoChoosePort")
        end)
        remap("r", "P[r]ogrammer", function()
            vim.cmd("ArduinoChooseProgrammer")
        end)
    end)
    wk.writeBuf()
end