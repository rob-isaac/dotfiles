-- [[ Keymaps ]]
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "switch windows" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "switch windows" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "switch windows" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "switch windows" })

vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "switch windows" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "switch windows" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "switch windows" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "switch windows" })

vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "vsplit window" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "split window" })
vim.keymap.set("n", "<leader>wc", "<cmd>close<cr>", { desc = "close window" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "close other windows" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "resize windows equally" })

vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabnext<cr>", { desc = "Prev tab" })

vim.keymap.set("n", "j", "gj", { desc = "visual move line" })
vim.keymap.set("n", "k", "gk", { desc = "visual move line" })

vim.keymap.set("i", "jk", "<esc>", { desc = "quick escape" })
vim.keymap.set("i", "jj", "<esc>", { desc = "quick escape" })

vim.keymap.set({ "i", "c" }, "<C-l>", "<right>", { desc = "quick move right" })
vim.keymap.set({ "i", "c" }, "<C-h>", "<left>", { desc = "quick move left" })

vim.keymap.set("c", "<C-j>", "<down>", { desc = "scroll command history" })
vim.keymap.set("c", "<C-k>", "<up>", { desc = "scroll command history" })

vim.keymap.set("n", "<leader>qq", "<cmd>wqa<cr>", { desc = "quick quit" })
vim.keymap.set("n", "<C-s>", "<cmd>update<cr>", { desc = "save buffer" })
vim.keymap.set("n", "<esc>", "<cmd>noh<cr>", { desc = "clear highlights" })

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "[C]ode [D]iagnostics" })
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "[C]ode Diagnostics [Q]uickfix" })

vim.keymap.set("n", "]<Space>", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, cur_line, cur_line, true, { "" })
end, { desc = "Insert line below" })
vim.keymap.set("n", "[<Space>", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(0, cur_line, cur_line, true, { "" })
end, { desc = "Insert line above" })
vim.keymap.set("n", "]q", "<cmd>silent cnext<cr>", { desc = "Next quickfix" })
vim.keymap.set("n", "[q", "<cmd>silent cprev<cr>", { desc = "Prev quickfix" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error next" })
vim.keymap.set("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error prev" })

vim.keymap.set("n", "n", "(v:searchforward ? 'n' : 'N')", { expr = true, desc = "Search Forward" })
vim.keymap.set("n", "N", "(v:searchforward ? 'N' : 'n')", { expr = true, desc = "Search Backward" })

vim.keymap.set("i", ",", ",<c-g>u", { desc = "Add undo break-point" })
vim.keymap.set("i", ".", ".<c-g>u", { desc = "Add undo break-point" })
vim.keymap.set("i", ";", ";<c-g>u", { desc = "Add undo break-point" })

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { desc = "Do nothing on spacabar" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>qc", "<cmd>cc<cr>", { desc = "[Q]uickfix [C]urrent" })

vim.keymap.set("n", "<leader>ql", require("utils").load_session, { desc = "Load session" })
vim.keymap.set("n", "<leader>qs", require("utils").save_session, { desc = "Load session" })

vim.keymap.set("n", "}", "<cmd>keepjumps normal! }<cr>", { desc = "No Jumplist on }" })
vim.keymap.set("n", "{", "<cmd>keepjumps normal! {<cr>", { desc = "No Jumplist on {" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

-- [[ Abbreviations ]]
vim.cmd("cabbr h vert help")
