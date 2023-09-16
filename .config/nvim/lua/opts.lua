vim.o.number = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.signcolumn = "yes"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.foldlevel = 1
vim.o.listchars = "tab:<->,eol:⤶,trail:-,"
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.scrolloff = 3
if vim.fn.executable("fish") then
  vim.o.shell = "fish"
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.loader.enable()
