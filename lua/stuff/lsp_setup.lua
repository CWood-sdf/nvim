return function()
	local lsp = require("lsp-zero")
	local wk = require("stuff.wkutils")
	lsp.preset("recommended")
	require("neodev").setup({})

	-- lsp.ensure_installed({
	--     'rust_analyzer',
	--     'clangd',
	--     'lua_ls',
	-- })

	-- Fix Undefined global 'vim'
	-- lsp.nvim_workspe()

	-- lsp.setup_nvim_cmp({
	--     mapping = cmp_mappings
	-- })

	-- lsp.set_preferences({
	-- 	suggest_lsp_servers = true,
	-- 	sign_icons = {
	-- 		error = "E",
	-- 		warn = "W",
	-- 		hint = "H",
	-- 		info = "I",
	-- 	},
	-- })

	---@diagnostic disable-next-line: unused-local
	local onAttach = function(args, bufnr)
		local opts = { buffer = bufnr, noremap = false }
		wk.remapNoGroup("n", "K", "Hover", function()
			vim.lsp.buf.hover()
		end, opts)
		wk.makeGroup("n", "<leader>v", "LSP", function(remap)
			remap("d", "[D]iagnostic float", function()
				vim.diagnostic.open_float()
			end, opts)
			remap("i", "[I]nlay hints", function()
				vim.lsp.inlay_hint(0, nil)
			end, opts)
			remap("h", "[H]over (K)", function()
				vim.lsp.buf.hover()
			end, opts)
			remap("a", "[A]ction", function()
				vim.lsp.buf.code_action()
			end, opts)
			remap("n", "[N]ext diagnostic (]d)", function()
				vim.diagnostic.goto_next()
			end, opts)
			remap("p", "[P]revious diagnostic ([d)", function()
				vim.diagnostic.goto_prev()
			end, opts)
			remap("s", "[S]ignature help (<C-h>)", function()
				vim.lsp.buf.signature_help()
			end, opts)
			remap("r", "[R]ename", function()
				vim.lsp.buf.rename()
			end, opts)
			remap("t", "[T]oggle trouble", function()
				vim.cmd("TroubleToggle")
			end, opts)
		end, opts)
		wk.makeGroup("n", "<leader>vg", "Goto", function(remap)
			remap("d", "[D]efinition (gd)", function()
				vim.lsp.buf.definition()
			end, opts)
			remap("i", "[I]mplementation (gI)", function()
				vim.lsp.buf.implementation()
			end, opts)
			remap("t", "[T]ype definition (gy)", function()
				vim.lsp.buf.type_definition()
			end, opts)
			remap("D", "[D]eclaration (gD)", function()
				vim.lsp.buf.declaration()
			end, opts)
			remap("r", "[R]eferences (gr)", function()
				vim.lsp.buf.references()
			end, opts)
		end, opts)
		wk.makeGroup("n", "<leader>vw", "Workspace", function(remap)
			remap("s", "[S]ymbols", function()
				vim.lsp.buf.workspace_symbol()
			end, opts)
		end, opts)
		wk.writeBuf()
	end
	---@diagnostic disable-next-line: unused-local
	lsp.on_attach(onAttach)
	if jit.os == "Windows" then
		require("lspconfig").arduino_language_server.setup({
			-- cmd = { "node", --[[ "run", ]] "C:/Users/woodc/ar_ls_inter_client/index.js" },
			cmd = {
				"C:\\Users\\woodc\\AppData\\Local\\nvim-data\\mason\\bin\\arduino-language-server.cmd",
				"-clangd",
				"C:\\Users\\woodc\\AppData\\Local\\nvim-data\\mason\\bin\\clangd.cmd",
				"-cli-config",
				"C:\\Users\\woodc\\appdata\\local\\arduino15\\arduino-cli.yaml",
				"-fqbn",
				"arduino:avr:pro",
				"-log",
				"true",
			},
		})
	else
		require("lspconfig").arduino_language_server.setup({
			cmd = {
				"node", --[[ "run", ]]
				"/mnt/c/Users/woodc/ar_ls_inter_client/index.js",
			},
		})
	end
	require("lspconfig").lua_ls.setup({
		settings = {
			Lua = {
				hint = {
					enable = true,
				},
			},
		},
	})
	require("lspconfig").rust_analyzer.setup({})
	require("lspconfig").clangd.setup({})
	require("lspconfig").tsserver.setup({})
	require("lspconfig").svelte.setup({})
	require("lspconfig").prosemd_lsp.setup({})
	require("lspconfig").gopls.setup({})
	require("lspconfig").vimls.setup({})
	require("lspconfig").yamlls.setup({})
	require("lspconfig").jsonls.setup({})
	require("lspconfig").html.setup({})
	require("lspconfig").zls.setup({})
	require("lspconfig").eslint.setup({})
	require("lspconfig").bashls.setup({})
	lsp.setup()

	vim.diagnostic.config({
		virtual_text = true,
	})

	local id = nil
	wk.useGroup("n", "<leader>v", function(remap)
		remap("L", "LSP restart", function()
			if id ~= nil then
				vim.lsp.stop_client(id)
				id = nil
			end
			---@diagnostic disable-next-line: missing-fields
			id = vim.lsp.start_client({
				filetypes = { "maple", "mpl" },
				name = "maple",
				cmd = { "/home/cwood/projects/maple/lsp/target/debug/maple-lsp" },
				---@diagnostic disable-next-line: assign-type-mismatch
				root_dir = vim.fs.dirname(vim.fs.find({ "maple.mpl" }, { upward = true })[1]),
				---@diagnostic disable-next-line: assign-type-mismatch
				cmd_cwd = vim.fn.getcwd(),
			})
			local bufnr = vim.api.nvim_get_current_buf()
			if vim.lsp.buf_is_attached(bufnr, id or -1) then
				return
			end
			print("Attaching maple lsp")
			local ok = vim.lsp.buf_attach_client(bufnr, id or -1)
			if not ok then
				print("Failed to attach maple lsp")
			end
		end)
		remap("D", "LSP stop", function()
			if id ~= nil then
				local bufnr = vim.api.nvim_get_current_buf()
				vim.lsp.buf_detach_client(bufnr, id)
				vim.lsp.stop_client(id)
			else
				print("LSP not running")
			end
		end)
	end)
end
