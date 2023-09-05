vim.o.clipboard = "unnamedplus"
vim.o.number = false
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.signcolumn = "yes"
vim.o.makeprg = "ninja"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.foldlevel = 99
if vim.fn.executable("fish") then
  vim.o.shell = "fish"
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.jupytext_fmt = "py"

vim.loader.enable()

-- N.B. the builtin clipboard detection is slow
if vim.fn.has("win32") == 1 or vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
  }
elseif vim.fn.has("unix") == 1 then
  if vim.fn.executable("xclip") == 1 then
    vim.g.clipboard = {
      copy = {
        ["+"] = "xclip -selection clipboard",
        ["*"] = "xclip -selection clipboard",
      },
      paste = {
        ["+"] = "xclip -selection clipboard -o",
        ["*"] = "xclip -selection clipboard -o",
      },
    }
  elseif vim.fn.executable("xsel") == 1 then
    vim.g.clipboard = {
      copy = {
        ["+"] = "xsel --clipboard --input",
        ["*"] = "xsel --clipboard --input",
      },
      paste = {
        ["+"] = "xsel --clipboard --output",
        ["*"] = "xsel --clipboard --output",
      },
    }
  end
end
