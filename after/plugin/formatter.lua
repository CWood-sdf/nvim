-- Utilities for creating configurations
-- }
-- local util = require("formatter.util")
local masonRegistry = require 'mason-registry'
---@diagnostic disable-next-line: unused-local, unused-function
local UseMasonFormatter = function(type, name)
    local fmt = require("formatter.filetypes." .. type)[name]
    if (fmt == nil) then
        error("can't find formatter default for " .. name, 1)
    end
    if (masonRegistry.is_installed(fmt().exe) == false) then
        print("Mason formatter " .. fmt().exe .. " not installed")
    end
    return fmt
end
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
        typescript = {
            UseMasonFormatter("typescript", "prettier"),
        },
        javascript = {
            UseMasonFormatter("javascript", "prettier"),
        },
        css = {
            UseMasonFormatter("css", "prettier")
        },
        html = {
            UseMasonFormatter("html", "prettier")
        },
        markdown = {
            UseMasonFormatter("markdown", "prettier")
        },
        -- lua = {
        --     UseMasonFormatter("lua", "stylua"),
        -- },
        -- Formatter configurations for filetype "lua" go here
        -- and will be executed in order
        -- lua = {
        -- 	UseMasonFormatter("lua", "stylua"),
        -- 	-- -- "formatter.filetypes.lua" defines default configurations for the
        -- 	-- -- "lua" filetype
        -- 	-- require("formatter.filetypes.lua").stylua,
        -- 	--
        -- 	-- -- You can also define your own configuration
        -- 	-- function()
        -- 	--     -- Full specification of configurations is down below and in Vim help
        -- 	--     -- files
        -- 	--     return {
        -- 	--         exe = vim.fn.stdpath("data") .. "/mason/bin/" .. "stylua",
        -- 	--         args = {
        -- 	--             "--search-parent-directories",
        -- 	--             "--stdin-filepath",
        -- 	--             util.escape_path(util.get_current_buffer_file_path()),
        -- 	--             "--",
        -- 	--             "-",
        -- 	--         },
        -- 	--         stdin = true,
        -- 	--     }
        -- 	-- end,
        -- 	--
        -- },

    },
})
function Format()
    local lspFormatSuccess = false
    local lspFormat = function()
        vim.lsp.buf.format({
            filter = function(client)
                if (not client.server_capabilities.documentFormattingProvider) then
                    return false
                end
                lspFormatSuccess = true
                return true
            end,
        })
    end
    local formatter = require("formatter.config").values.filetype[vim.bo.filetype]
    if (formatter ~= nil and masonRegistry.is_installed(formatter[1]().exe)) then
        vim.cmd("Format")
        return true
    end
    lspFormat()
    if (lspFormatSuccess) then
        return
    end
end

-- AUTOFORMAT!!!!!
vim.cmd([[augroup Format
    autocmd!
    autocmd BufWritePre * lua Format()
augroup END
]])
