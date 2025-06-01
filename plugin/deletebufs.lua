vim.api.nvim_create_user_command("DeleteHiddenBuffers", function(args)
	local tabpage = vim.fn.tabpagenr('$')

	local openBufs = {}
	for i = 1, tabpage do
		local tbbufs = vim.fn.tabpagebuflist(i)
		for _, v in ipairs(tbbufs) do
			openBufs[v] = true
		end
	end
	local filtered = {}
	local allbufs = vim.api.nvim_list_bufs()

	for _, v in ipairs(allbufs) do
		if openBufs[v] ~= true then
			table.insert(filtered, v)
		end
	end
	for _, buf in ipairs(filtered) do
		vim.api.nvim_buf_delete(buf, {
			force = args.bang,
		})
	end
end, {
	bang = true
})
