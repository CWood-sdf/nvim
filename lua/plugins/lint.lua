return {
	"mfussenegger/nvim-lint",
	config = function()
		require("lint").linters_by_ft = {
			-- cpp = { 'cpplint' },
			-- cpp = { 'clang-tidy' },
			-- cmake = { 'cmakelint' },
			make = { "checkmake" },
			-- lua = { "selene" },
		}
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
	event = "BufReadPre",
	-- keys = { {
	-- 	"<C-l>",
	-- 	function()
	-- 		require("lint").try_lint()
	-- 	end,
	-- } },
}
