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
	groupOpts = {}
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
	else
		groupOpts = {}
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
	-- if M.remaps[mode] == nil then
	--
	-- end
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
	if opts == nil then
		opts = {}
	end
	opts = opts or {}
	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			M.remapNoGroup(m, key, desc, func, opts)
		end
		return
	end
	if M.remaps[mode] == nil then
		M.remaps[mode] = {}
	end
	M.remaps[mode][key] = { func, desc }
	for k, v in pairs(opts) do
		M.remaps[mode][key][k] = v
	end
end

function M.writeBuf()
	local newRemaps = {}
	for k, v in pairs(M.remaps) do
		if newRemaps[k] == nil then
			newRemaps[k] = {}
		end
		for k2, v2 in pairs(v) do
			if v2.name ~= nil then
				newRemaps[k][k2] = v2
			end
		end
		local opts = {}
		opts.mode = k
		whichkey.register(v, opts)
	end
	M.remaps = newRemaps
end

return M
