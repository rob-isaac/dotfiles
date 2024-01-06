local map = require("utils").map

-- Don't do anything for space in normal mode
map({ "n", "v" }, "<Space>", "<Nop>", { desc = "Do nothing on spacabar" })

-- Escape to clear highlights
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Better buffer switching
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Make n and N consistent regardless of search direction
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Search downwards" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Search upwards" })

-- Add undo break-points at punctuation
map("i", ",", ",<c-g>u", { desc = "Add undo break-point" })
map("i", ".", ".<c-g>u", { desc = "Add undo break-point" })
map("i", ";", ";<c-g>u", { desc = "Add undo break-point" })

-- better visual indenting
map("v", "<", "<gv", { desc = "Interactive visual indent" })
map("v", ">", ">gv", { desc = "Interactive visual indent" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>ws", "<C-W>s", { desc = "Split window" })
map("n", "<leader>wv", "<C-W>v", { desc = "Vsplit window" })

-- bracket jumps
map("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostic next" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostic prev" })
map("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error next" })
map("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error prev" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Quickfix next" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Quickfix prev" })
map("n", "]l", "<cmd>lnext<cr>", { desc = "Loclist next" })
map("n", "[l", "<cmd>lprev<cr>", { desc = "Loclist prev" })

-- Quick quit
map("n", "<leader>qq", "<cmd>wa|qa<cr>", { desc = "Quick Quit" })

-- Don't set jumplist on {} motions
map("n", "}", "<cmd>keepjumps normal! }<cr>")
map("n", "{", "<cmd>keepjumps normal! {<cr>")

-- Copy-to/Paste-from System Clipboard
map({ "n", "v" }, "<leader>y", [["+y]])
map({ "n", "v" }, "<leader>p", [["+p]])
