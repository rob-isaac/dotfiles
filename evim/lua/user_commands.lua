vim.api.nvim_create_user_command("ConfigEdit", "e $MYVIMRC", { desc = "Edit Config" })

vim.api.nvim_create_user_command("SwapWords", function(opts)
	if #opts.fargs ~= 2 then
		print("Usage SwapWords <word1> <word2>")
		return
	end
	local word1 = vim.fn.escape(opts.fargs[1], [[\/]])
	local word2 = vim.fn.escape(opts.fargs[2], [[\/]])
	vim.cmd(
		string.format(
			[[:%d,%ds/\<%s\>\|\<%s\>/\={'%s':'%s','%s':'%s'}[submatch(0)]/g]],
			opts.line1,
			opts.line2,
			word1,
			word2,
			word1,
			word2,
			word2,
			word1
		)
	)
end, { nargs = "*", range = true, desc = "Swap Two Words" })

local function toggle_list(qf)
	local str = qf and "quickfix" or "loclist"
	local cmd = qf and "copen" or "lopen"
	local windows = vim.fn.getwininfo()
	for _, win in pairs(windows) do
		if win[str] == 1 then
			vim.cmd.cclose()
			return
		end
	end
	vim.cmd([[botright ]] .. cmd .. [[ 8]])
end

vim.api.nvim_create_user_command("ToggleQf", function()
	toggle_list(true)
end, { nargs = 0, desc = "Toggle Quickfix List" })

vim.api.nvim_create_user_command("ToggleLoc", function()
	toggle_list(true)
end, { nargs = 0, desc = "Toggle Location List" })
