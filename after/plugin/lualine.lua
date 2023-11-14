-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
-- CWood-sdf additions: Copilot status, formatting name, debug name
local lualine = require("lualine")
--needed bc lualine with bold in gui is rlly ugly
local boldSetting = ""
vim.defer_fn(function()
	boldSetting = (function()
		if vim.fn.exists("GuiFont") == 1 then
			return "bold"
		end
		return "bold"
	end)()
end, 500)
-- Color table for highlights
-- stylua: ignore
local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}
local function getModeColor()
	-- auto change color according to neovims mode
	local mode_color = {
		n = colors.red,
		i = colors.green,
		v = colors.blue,
		[""] = colors.blue,
		V = colors.blue,
		[""] = colors.blue,
		c = colors.magenta,
		no = colors.red,
		s = colors.orange,
		S = colors.orange,
		ic = colors.yellow,
		R = colors.violet,
		Rv = colors.violet,
		cv = colors.red,
		ce = colors.red,
		r = colors.cyan,
		rm = colors.cyan,
		["r?"] = colors.cyan,
		["!"] = colors.red,
		t = colors.green,
	}
	return { bg = mode_color[vim.fn.mode()], fg = "#000000" }
end

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

-- Config
local config = {
	globalstatus = true,
	options = {
		globalstatus = true,
		-- Disable sections and component separators
		component_separators = "",
		section_separators = "",
		theme = "tokyonight",
	},
	sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		-- These will be filled later
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		-- these are to remove the defaults
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

-- ins_left({
--     function()
--         return "▊"
--     end,
--     color = getModeColor,
--     padding = { left = 0, right = 0 }, -- We don't need space before this
-- })
-- sdf
ins_left({
	"filename",
	color = getModeColor,
	cond = conditions.buffer_not_empty,
	-- color = { fg = "#aaaaff", gui = boldSetting },
})

ins_left({ "progress" })
ins_left({ "location" })

ins_left({
	"o:encoding", -- option component same as &encoding in viml
	cond = conditions.hide_in_width,
	color = { fg = colors.green, gui = boldSetting },
})

ins_left({
	"fileformat",
	fmt = string.upper,
	icons_enabled = true,
	color = { fg = colors.green, gui = boldSetting },
})

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.cyan },
	},
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
	function()
		return "%="
	end,
})
local hasEnteredFile = false
local auGroup = vim.api.nvim_create_augroup("Lualine", {})
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*.*",
	group = auGroup,
	callback = function()
		hasEnteredFile = true
		vim.api.nvim_clear_autocmds({
			group = auGroup,
		})
	end,
})
ins_left({
	-- Lsp server name .
	function()
		if hasEnteredFile == false then
			return ""
		end
		local hasLsp = false
		local hasFmt = false
		local hasDbg = false
		local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
		local clients = vim.lsp.get_clients()
		if next(clients) == nil then
			hasLsp = false
		end
		for _, client in ipairs(clients) do
			if client.server_capabilities.documentFormattingProvider then
				-- remove last two chars of sign
				-- sign = sign .. format_sign
				-- format_sign = ""
				hasFmt = true
			end
			---@diagnostic disable-next-line: undefined-field
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				-- msg = client.name
				-- msg = sign .. msg
				-- return sign
				hasLsp = true
			end
		end
		if #require("conform").list_formatters(vim.api.nvim_get_current_buf()) > 0 then
			hasFmt = true
		end
		-- local formatter = require("formatter.config").values.filetype[vim.bo.filetype]
		-- if formatter ~= nil and masonRegistry.is_installed(formatter[1]().exe) then
		--     hasFmt = true
		-- end
		if HasDapSetup() then
			local dap = require("dap")
			local has_dap = dap.configurations[vim.bo.filetype] ~= nil
			if has_dap then
				hasDbg = true
			end
		end
		local ret = ""
		if hasLsp then
			ret = " "
		end
		if hasFmt then
			ret = ret .. " "
		end
		if hasDbg then
			ret = ret .. " "
		end
		return ret
	end,
	color = { fg = "#ffffff", gui = boldSetting },
})
-- ins_left({
--     function()
--         local sign = " "
--         local formatter = require("formatter.config").values.filetype[vim.bo.filetype]
--         if formatter ~= nil and masonRegistry.is_installed(formatter[1]().exe) then
--             return sign .. formatter[1]().exe
--         end
--         return ""
--     end,
--     color = { fg = "#ffffff", gui = boldSetting },
-- })
--
-- ins_left {
--     function()
--         local dap = require 'dap'
--         local has_dap = dap.configurations[vim.bo.filetype] ~= nil
--         if has_dap == false then
--             return ""
--         end
--
--         return " "
--     end,
--     color = { fg = "#ffffff", gui = boldSetting },
-- }

local startTime = nil
-- Add components to right sections
local hasInternet = false
local lastInternetCheck = 0
ins_right({
	function()
		if not hasInternet or (vim.uv.hrtime() - lastInternetCheck) > 10000000000 then
			vim.fn.jobstart("ping google.com -c 1", {
				on_exit = function(_, code)
					if code == 0 then
						hasInternet = true
					else
						hasInternet = false
					end
				end,
			})
		end
		if not hasInternet then
			return "󰖪"
		end
		if hasEnteredFile == false then
			return ""
		elseif startTime == nil then
			startTime = vim.uv.hrtime()
			return ""
		end
		if vim.uv.hrtime() - startTime > 100000000 then
			local output = vim.api.nvim_exec2("Copilot status", { output = true }).output

			if output:find("Not logged in") then
				return ""
			elseif output:find("Enabled") then
				return ""
			elseif output:find("Disabled") then
				return ""
			else
				return ""
			end
		else
			return "󰔟"
		end
	end,
})
ins_right({
	"filetype",
	icon_only = false,
	icon = {
		align = "left",
	},
})

ins_right({
	"diff",
	-- Is it me or the symbol for modified us really weird
	symbols = { added = " ", modified = " ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = "#ffbb00" },
		removed = { fg = colors.red },
	},
})

ins_right({
	"branch",
	icon = "",
	color = getModeColor,
})

-- ins_right({
--     function()
--         return "▊"
--     end,
--     color = getModeColor,
--     padding = { left = 1 },
-- })

-- Now don't forget to initialize lualine
lualine.setup(config)
