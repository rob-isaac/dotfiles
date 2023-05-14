-- open taskwarrior ui in floating terminal
vim.keymap.set("n", "<leader>tw", function()
  require("lazyvim.util").float_term("taskwarrior-tui")
end, { desc = "Taskwarrior TUI" })

-- remove the builtin mapping for S-CR in command mode
vim.keymap.del("c", "<S-CR>")

-- better switching
local ss = require("smart-splits")
vim.keymap.set("n", "<A-h>", ss.resize_left)
vim.keymap.set("n", "<A-j>", ss.resize_down)
vim.keymap.set("n", "<A-k>", ss.resize_up)
vim.keymap.set("n", "<A-l>", ss.resize_right)
vim.keymap.set("n", "<C-h>", ss.move_cursor_left)
vim.keymap.set("n", "<C-j>", ss.move_cursor_down)
vim.keymap.set("n", "<C-k>", ss.move_cursor_up)
vim.keymap.set("n", "<C-l>", ss.move_cursor_right)
vim.keymap.set("n", "<leader><C-h>", ss.swap_buf_left)
vim.keymap.set("n", "<leader><C-j>", ss.swap_buf_down)
vim.keymap.set("n", "<leader><C-k>", ss.swap_buf_up)
vim.keymap.set("n", "<leader><C-l>", ss.swap_buf_right)
