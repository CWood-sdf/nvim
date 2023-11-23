return function()
	local dapui = require("dapui")
	require("mason-nvim-dap").setup({
		ensure_installed = {},
		automatic_installation = false,
		handlers = {}, -- sets up dap in the predefined manner
	})

	local dap = require("dap")
	dap.configurations.cuda = dap.configurations.cpp
	dap.listeners.after.event_initialized["dapui_config"] = function()
		require("lualine").hide({
			unhide = false,
			place = { "statusline" },
		})
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
		require("lualine").hide({
			unhide = true,
			place = { "statusline" },
		})
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
		require("lualine").hide({
			unhide = true,
			place = { "statusline" },
		})
	end
	dapui.setup()
	local wk = require("stuff.wkutils")
	local function terminateDap()
		dapui.close()
		vim.cmd("DapTerminate")
	end
	wk.makeGroup("n", "<leader>d", "[D]ebug", function(remap)
		remap("i", "Step [I]nto (<F11>)", vim.cmd.DapStepInto)
		remap("o", "Step [O]ut (<F12>)", vim.cmd.DapStepOut)
		remap("s", "[S]tep Over (<F10>)", vim.cmd.DapStepOver)
		remap("t", "[T]erminate (<S-F5>)", terminateDap)
	end)
	wk.makeGroup("n", "<leader>du", "[U]i", function(remap)
		remap("t", "[T]oggle", function()
			dapui.toggle()
		end)
		remap("c", "[C]lose", function()
			dapui.close()
		end)
		remap("o", "[O]pen", function()
			dapui.open()
		end)
	end)
	wk.writeBuf()
end
