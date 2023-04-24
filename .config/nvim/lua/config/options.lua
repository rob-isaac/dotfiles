vim.o.wrap = true
vim.o.number = false
vim.o.relativenumber = false
vim.o.termguicolors = true
vim.o.makeprg = "ninja"

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.jupytext_fmt = "py"
vim.g.clipboard = {
  name = "xsel",
  copy = {
    ["+"] = "xsel --nodetach -i -b",
    ["*"] = "xsel --nodetach -i -p",
  },
  paste = {
    ["+"] = "xsel  -o -b",
    ["*"] = "xsel  -o -b",
  },
  cache_enabled = 1,
}
