return {
    "stevearc/conform.nvim",
    config = function()
        local Config = require("stuff.config")
        Config.addFlag("plugins.conform.autoformat")
        Config.set("plugins.conform.autoformat", true)
        require("conform").setup({
            formatters = {
                superhtml = {
                    inherit = false,
                    command = "superhtml",
                    stdin = true,
                    args = { "fmt", "--stdin-super" },
                },
                ziggy = {
                    inherit = false,
                    command = "ziggy",
                    stdin = true,
                    args = { "fmt", "--stdin" },
                },
                ziggy_schema = {
                    inherit = false,
                    command = "ziggy",
                    stdin = true,
                    args = { "fmt", "--stdin-schema" },
                },
            },
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
                shtml = { "superhtml" },
                ziggy = { "ziggy" },
                ziggy_schema = { "ziggy_schema" },
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
    event = "BufWritePre",
}
