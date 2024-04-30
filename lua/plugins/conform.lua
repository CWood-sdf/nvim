local Config = require('stuff.config')
Config.addFlag("plugins.conform.autoformat")
Config.set("plugins.conform.autoformat", true)
return {
    "stevearc/conform.nvim",
    opts = {
        format_on_save = function()
            if not Config.get("plugins.conform.autoformat") then
                return
            end
            return {
                lsp_fallback = true,
                timeout_ms = 1000,
            }
        end,
        formatters_by_ft = {
            cpp = { "clang-format" },
            arduino = { "clang-format" },
            asm = { "asmfmt" },
            c = { "clang-format" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            markdown = { "prettier" },
            yaml = { "prettier" },
            python = { "black" },
            py = { "black" },
            bash = { "beautysh" },
            sh = { "beautysh" },
            handlebars = { "djlint" },
            java = { "google-java-format" },
        },
        notify_on_error = false,
    },
    event = "User SpaceportDone",
}
