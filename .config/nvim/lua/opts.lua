-- no line numbers, but keep the sign column
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"

-- wait 300ms for keybindings
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- split to the bottom/right
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 4 spaces instead of tabs
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = -1
vim.opt.shiftwidth = 0

-- highlight the line of the cursor location
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line"

-- semi-transparency for popup-menu + floating-windows
vim.opt.pumblend = 10
vim.opt.winblend = 5

-- start scrolling before cursor is at the edge of the window
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5

-- wrap whole words
vim.opt.wrap = true
vim.opt.linebreak = true

-- show some helper symbols
vim.opt.list = true
vim.opt.listchars = "tab:<->,eol:⤶,trail:-,"

-- add spell checking
vim.opt.spelllang = { "en_us" }
vim.opt.spell = true

-- be smart about case-sensitivity for search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- best effort on indentation for new line
vim.opt.smartindent = true
vim.opt.copyindent = true
vim.opt.breakindent = true

-- better colors
vim.opt.termguicolors = true

-- allow hidden buffers (e.g. don't unload abandoned buffers)
vim.opt.hidden = true

-- persist undo information across sessions
vim.opt.undofile = true

-- end of buffer column fill (instead of ~)
vim.opt.fillchars = { eob = " " }

-- show popup-menu even on one entry + preview information
vim.opt.completeopt = "menuone,preview"

-- save more things on session
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- use space as leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable node/perl providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- use python host program from the environment
vim.g.python3_host_prog = "/usr/bin/env python3"

-- use the experimental module loader
vim.loader.enable()

-- use fish as the terminal shell if available
if vim.fn.executable("fish") then
  vim.opt.shell = "fish"
end
