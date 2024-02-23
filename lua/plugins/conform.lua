return {
    "stevearc/conform.nvim",
    opts = {
        format_on_save = {
            lsp_fallback = true,
            timeout_ms = 1000,
        },
        formatters_by_ft = {
            -- lua = { "stylua" },
            cpp = { "clang-format" },
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
        },
        notify_on_error = true,
    },
    event = "User SpaceportDone",
}
