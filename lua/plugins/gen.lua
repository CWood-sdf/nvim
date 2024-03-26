return {
    "David-Kunz/gen.nvim",
    config = function()
        require('gen').setup({
            model = "mistral",
        })
        require('gen').prompts["ScreenReader"] = {
            prompt =
            "Regarding the following text, Please rewrite the following $filetype code into so that it can be read by a screen reader, do not change the code in any way except to add comments: \n$text",
        }
        require('gen').prompts["ScreenReader2"] = {
            prompt =
            "Regarding the following text, Please rewrite the following $filetype code into english so that it can be read by a screen reader, the code may be partial, do not respond with code: \n$text",
        }
    end,
    cmd = "Gen",
}
