vim.keymap.set("n", "<C-n>", function()
  local list = vim.fn.getqflist()
  local cpos = vim.api.nvim_win_get_cursor(0)
  for i = cpos[1] + 1, #list do
    local line = list[i]
    if line.valid == 1 then
      cpos[1] = i
      cpos[2] = 0
      vim.api.nvim_win_set_cursor(0, cpos)
      return
    end
  end
end, { buffer = true, desc = "Jump Forward to Valid" })

vim.keymap.set("n", "<C-p>", function()
  local list = vim.fn.getqflist()
  local cpos = vim.api.nvim_win_get_cursor(0)
  for i = cpos[1] - 1, 1, -1 do
    local line = list[i]
    if line.valid == 1 then
      cpos[1] = i
      cpos[2] = 0
      vim.api.nvim_win_set_cursor(0, cpos)
      return
    end
  end
end, { buffer = true, desc = "Jump Backward to Valid" })

vim.keymap.set("n", "u", "<cmd>colder<cr>", { desc = "Restore previous quickfix", buffer = true })
vim.keymap.set("n", "<C-r>", "<cmd>cnewer<cr>", { desc = "Restore next quickfix", buffer = true })
