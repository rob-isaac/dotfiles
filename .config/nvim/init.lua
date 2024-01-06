local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim....")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set options, autocmds, and mappings
require("opts")
require("autocmds")
require("mappings")

-- Load plugins
require("lazy").setup({
  spec = { import = "plugins" },
  install = { colorscheme = { "gruvbox-material", "tokyonight", "habamax" } },
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
  change_detection = { notify = false },
  ---@diagnostic disable-next-line: assign-type-mismatch
  dev = { path = "~/repos/", patterns = { "rob-isaac" } },
})
