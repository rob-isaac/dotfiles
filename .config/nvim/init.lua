vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.opt.grepprg = "rg --vimgrep"
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", eol = "⤶" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5
vim.opt.hlsearch = true
vim.opt.number = false
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.winblend = 5
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldlevelstart = 99
if vim.fn.executable("fish") then
  vim.opt.shell = "fish"
end

-- [[ Basic Keymaps ]]

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "[C]ode [D]iagnostics" })
vim.keymap.set("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "[C]ode Diagnostics [Q]uickfix" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "]<Space>", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, cur_line, cur_line, true, { "" })
end, { desc = "Insert line below" })
vim.keymap.set("n", "[<Space>", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(0, cur_line, cur_line, true, { "" })
end, { desc = "Insert line above" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Prev quickfix" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error next" })
vim.keymap.set("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error prev" })

-- TODO: remove these once the muscle memory is gone
vim.keymap.set("n", "go", "<nop>", {})
vim.keymap.set("n", "gO", "<nop>", {})

vim.keymap.set("i", "<C-j>", "<nop>", {})
vim.keymap.set("i", "<C-k>", "<nop>", {})
vim.keymap.set("i", "<C-v>", "<nop>", {})
vim.keymap.set("i", "<C-e>", "<nop>", {})
vim.keymap.set("i", "<C-y>", "<nop>", {})

vim.keymap.set("i", "<C-c>", "<C-g>U<Esc>g~lg~bgi", { desc = "Swap case of last word" })
vim.keymap.set("i", "<C-s>", "<C-g>U<Esc>[s1z=gi", { desc = "Fix the last spelling" })
vim.keymap.set("i", "jj", "<Esc>", {})
vim.keymap.set("i", "jk", "<Esc>", {})

vim.keymap.set("c", "<C-j>", "<Down>", {})
vim.keymap.set("c", "<C-k>", "<Up>", {})
vim.keymap.set({ "i", "c" }, "<C-h>", "<Left>", {})
vim.keymap.set({ "i", "c" }, "<C-l>", "<Right>", {})

vim.keymap.set("n", "<leader>qq", "<cmd>wa|qa<cr>", { desc = "Quick Quit" })

vim.keymap.set("n", "}", "<cmd>keepjumps normal! }<cr>")
vim.keymap.set("n", "{", "<cmd>keepjumps normal! {<cr>")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

vim.keymap.set("i", ",", ",<c-g>u", { desc = "Add undo break-point" })
vim.keymap.set("i", ".", ".<c-g>u", { desc = "Add undo break-point" })
vim.keymap.set("i", ";", ";<c-g>u", { desc = "Add undo break-point" })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { desc = "Do nothing on spacabar" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- [[ Basic Abbreviations ]]

vim.cmd([[
cabbr h vert help
]])

-- [[ Basic Autocommands ]]

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", "VimResume" }, {
  group = vim.api.nvim_create_augroup("checktime", {}),
  command = "checktime",
  desc = "Check for file changes",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("restore_cursor", {}),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "restore cursor when opening buffer",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", {}),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "close some filetypes with q",
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter", "InsertEnter", "WinLeave" }, {
  group = vim.api.nvim_create_augroup("auto_hide_cursorline", {}),
  callback = function(args)
    if args.event == "InsertEnter" or args.event == "WinLeave" then
      local cl = vim.wo.cursorline
      if cl then
        vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
        vim.wo.cursorline = false
      end
    else
      local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
      if ok and cl then
        vim.wo.cursorline = true
        vim.api.nvim_win_del_var(0, "auto-cursorline")
      end
    end
  end,
  desc = "Hide cursorline when in other window or insert mode",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", {}),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Basic Usercommands ]]

vim.api.nvim_create_user_command(
  "Gcheck",
  "cexpr system('git diff --check')",
  { desc = "Load results from 'git diff --check' into quickfix" }
)

-- [[ Install `lazy.nvim` plugin manager ]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]

require("lazy").setup({
  { import = "plugins" },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  change_detection = {
    enabled = false,
  },
})

-- vim: ts=2 sts=2 sw=2 et
