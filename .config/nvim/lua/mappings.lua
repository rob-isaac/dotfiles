local map = require("utils").map

-- Don't do anything for space in normal mode
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Escape to clear highlights
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Better buffer switching
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Make n and N consistent regardless of search direction
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points at punctuation
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- better visual indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>ws", "<C-W>s", { desc = "Split window" })
map("n", "<leader>wv", "<C-W>v", { desc = "Vsplit window" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- bracket jumps
map("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostic forward" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostic backward" })
map("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error forward" })
map("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error backward" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Quickfix next" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Quickfix next" })
map("n", "]l", "<cmd>lnext<cr>", { desc = "Loclist next" })
map("n", "[l", "<cmd>lprev<cr>", { desc = "Loclist next" })

-- Quick quit
map("n", "<leader>qq", "<cmd>wa|qa<cr>", {desc = "Quick Quit"})
