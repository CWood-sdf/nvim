-- Utilities for creating configurations
-- }
-- local util = require("formatter.util")

---@diagnostic disable-next-line: unused-local, unused-function
local UseMasonFormatter = function(type, name)
    return require("formatter.filetypes." .. type)[name]
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
        css = {
            UseMasonFormatter("css", "prettier")
        },
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
local formatSuccess = true
function Format()
    formatSuccess = true
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
    lspFormat()
    if (lspFormatSuccess) then
        return
    elseif ((require("formatter.config").values.filetype[vim.bo.filetype]) ~= nil) then
        vim.cmd("Format")
        return true
    else
        formatSuccess = false
    end
end

function FormatPost()
    if not formatSuccess then
        print("Formatting failed for filetype: " .. vim.bo.filetype .. " through lsp and lack of configured formatter")
    end
end

-- AUTOFORMAT!!!!!
vim.cmd([[augroup Format
    autocmd!
    autocmd BufWritePre * lua Format()
    autocmd BufWritePost * lua FormatPost()
augroup END
]])
