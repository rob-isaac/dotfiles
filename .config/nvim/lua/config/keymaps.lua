-- open taskwarrior ui in floating terminal
-- TODO: Use toggleterm for the floating terminal
vim.keymap.set("n", "<leader>tw", function()
  require("lazyvim.util").float_term("taskwarrior-tui")
end, { desc = "Taskwarrior TUI" })

vim.keymap.del("c", "<S-CR>")
