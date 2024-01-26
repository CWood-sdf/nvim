return {
    "stevearc/vim-arduino",
    ft = (function()
        if jit.os == "Windows" then
            return "sdjfaksdhgksd"
        end
        vim.g.arduino_dir = os.getenv("HOME") .. "/snap/arduino-cli/45/.arduino15"
        vim.g.arduino_home_dir = os.getenv("HOME") .. "/snap/arduino-cli/45/.arduino15"
        return "arduino"
    end)(),
}
