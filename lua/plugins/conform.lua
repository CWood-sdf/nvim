local Config = require('stuff.config')
Config.addFlag("plugins.conform.autoformat")
Config.set("plugins.conform.autoformat", true)
return {
    "stevearc/conform.nvim",
    config = function()
        require('conform').setup({
            format_on_save = function()
                if not Config.get("plugins.conform.autoformat") then
                    return
                end
                -- if vim.bo.filetype == "zig" then
                --     return
                -- end
                return {
                    lsp_fallback = true,
                    timeout_ms = 1000,
                }
            end,
            formatters_by_ft = {
                -- lua = { "stylua" },
                cpp = { "clang-format" },
                arduino = { "clang-format" },
                asm = { "asmfmt" },
                c = { "clang-format" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                html = { "prettier" },
                nml = { "prettier" },
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
            notify_on_error = true,
        })
    end,
    event = "User SpaceportDone",
}
