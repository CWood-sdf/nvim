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
                -- if vim.bo.filetype == "python" then
                --     return {
                --         lsp_fallback = false,
                --         timeout_ms = 1000,
                --     }
                -- end
                return {
                    lsp_fallback = true,
                    timeout_ms = 1000,
                }
            end,
            formatters_by_ft = {
                -- lua = { "stylua" },
                -- cpp = { "clang-format" },
                -- java = { "clang-format" },
                -- arduino = { "clang-format" },
                -- asm = { "asmfmt" },
                -- c = { "clang-format" },
                javascript = { "biome" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
                json = { "biome" },
                html = { "biome" },
                nml = { "biome" },
                css = { "biome" },
                markdown = { "biome" },
                yaml = { "biome" },
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
