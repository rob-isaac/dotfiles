-- [[ Global Settings ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- [[ Options ]]
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 3
vim.o.sidescrolloff = 5
vim.o.spell = true
vim.o.spelllang = "en_us"
vim.o.pumblend = 10
vim.o.pumheight = 10
vim.o.winblend = 5
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.completeopt = "menuone,popup"
vim.o.cmdheight = 0
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", eol = "⤶" }
if vim.fn.executable("fish") then
  vim.opt.shell = "fish"
end
