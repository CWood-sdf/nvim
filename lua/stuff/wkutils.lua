local whichkey = require("which-key")

local M = {}

M.remaps = {}

local groupOpts = {}
local currentGroup = ""
local currentGroupMode = ""

local remap = function(key, desc, func, opts)
	opts = opts or {}
	for k, v in pairs(groupOpts) do
		if opts[k] == nil then
			opts[k] = v
		end
	end
	local keys = currentGroup .. key
	M.remaps[currentGroupMode][keys] = { func, desc }
	for k, v in pairs(opts) do
		M.remaps[currentGroupMode][keys][k] = v
	end
	-- if there's a '(...)' in the desc, then remap that key to the func too
	if desc:find("%(") ~= nil then
		local desc2 = desc:gsub("%(.*%)", "")
		-- strip [ and ] from desc2
		desc2 = desc2:gsub("%[", "")
		desc2 = desc2:gsub("%]", "")
		local newKey = desc:match("%((.-)%)")
		M.remapNoGroup(currentGroupMode, newKey, desc2, func, opts)
	end
end

function M.feedKeys(keys, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), mode, true)
end

---@param mode string|string[]
---@param key string
---@param desc string
---@param makeRemaps fun(remap: fun(key: string, desc: string, func: fun() | string, opts: table?))
function M.makeGroup(mode, key, desc, makeRemaps, opts)
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			M.makeGroup(m, key, desc, makeRemaps, opts)
		end
		return
	end
	if M.remaps[mode] == nil then
		M.remaps[mode] = {}
	end
	M.remaps[mode][key] = {
		name = desc,
	}
	if opts ~= nil then
		for k, v in pairs(opts) do
			M.remaps[mode][key][k] = v
		end
		groupOpts = opts
	end
	currentGroup = key
	currentGroupMode = mode

	if makeRemaps ~= nil then
		makeRemaps(remap)
	end
end

function M.useGroup(mode, key, makeRemaps)
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			M.useGroup(m, key, makeRemaps)
		end
		return
	end
	if M.remaps[mode] == nil then
		error("Can't use group " .. key .. " in mode " .. mode .. " because it doesn't exist")
	end
	currentGroup = key
	currentGroupMode = mode

	if makeRemaps ~= nil then
		makeRemaps(remap)
	end
end

---@param mode string|string[]
---@param key string
---@param desc string
---@param func fun() | string
---@param opts table?
function M.remapNoGroup(mode, key, desc, func, opts)
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			M.remapNoGroup(m, key, desc, func, opts)
		end
		return
	end
	opts = opts or {}
	if M.remaps[mode] == nil then
		M.remaps[mode] = {}
	end
	M.remaps[mode][key] = { func, desc }
	for k, v in pairs(opts) do
		M.remaps[mode][key][k] = v
	end
end

function M.writeBuf()
	for k, v in pairs(M.remaps) do
		local opts = {}
		opts.mode = k
		whichkey.register(v, opts)
	end
end

return M
