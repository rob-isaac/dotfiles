-- [[ Options ]]

vim.o.breakindent = true
vim.o.confirm = true
vim.o.expandtab = true
vim.o.grepprg = "rg --vimgrep"
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.laststatus = 3
vim.o.list = true
vim.o.mouse = "a"
vim.o.scrolloff = 3
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.sidescrolloff = 10
vim.o.sidescrolloff = 5
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.spell = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 2
vim.o.timeoutlen = 300
vim.o.undofile = true
vim.o.updatetime = 250
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Basic Keymaps ]]

vim.keymap.set("i", "jk", "<Esc>", { desc = "quick escape" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "quick noh" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "quick exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "quick window switch" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "quick window switch" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "quick window switch" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "quick window switch" })

vim.keymap.set("n", "<C-s>", "<cmd>update<CR>", { desc = "quick save" })

vim.keymap.set("c", "<C-k>", "<Up>", { desc = "quick scroll history" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "quick scroll history" })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "quick yank to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>Y", '"+Y', { desc = "quick yank to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "quick paste from system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "quick paste from system clipboard" })

-- [[ Install `lazy.nvim` ]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]

require("lazy").setup({
  "justinmk/vim-dirvish",
  "justinmk/vim-sneak",
  "tpope/vim-abolish",
  "tpope/vim-dispatch",
  "tpope/vim-endwise",
  "tpope/vim-eunuch",
  "tpope/vim-fugitive",
  "tpope/vim-obsession",
  "tpope/vim-projectionist",
  "tpope/vim-repeat",
  "tpope/vim-sleuth",
  "tpope/vim-speeddating",
  "tpope/vim-unimpaired",
  "wellle/targets.vim",

  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "folke/lazydev.nvim",
  "ibhagwan/fzf-lua",
  "kylechui/nvim-surround",
  "lewis6991/gitsigns.nvim",
  "mason-org/mason-lspconfig.nvim",
  "mason-org/mason.nvim",
  "neovim/nvim-lspconfig",
  "nvim-lualine/lualine.nvim",
  "nvim-tree/nvim-web-devicons",
  "nvim-treesitter/nvim-treesitter-context",
  "nvim-treesitter/nvim-treesitter-textobjects",
  "stevearc/conform.nvim",
  { "EdenEast/nightfox.nvim", priority = 1000 },
  { "L3MON4D3/LuaSnip", version = "*", build = "make install_jsregexp" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "saghen/blink.cmp", version = "*" },
  install = { colorscheme = { "nightfox", "default" } },
  checker = { enabled = false },
  rocks = { enabled = false },
})

-- My configs.
require("autocmds")
require("usercmds")

-- Simple packages.
require("mason").setup()
require("nvim-surround").setup()

-- UI.
require("nightfox").setup({
  options = {
    styles = {
      comments = "italic",
      keywords = "bold",
      types = "italic,bold",
    },
  },
})
vim.cmd.colorscheme("nightfox")
require("lualine").setup({})

-- Tool Installer.
require("mason-tool-installer").setup({
  ensure_installed = {
    -- Language servers.
    "lua_ls",
    "clangd",
    "bashls",
    "jsonls",
    "fish_lsp",
    -- Formatters.
    "stylua",
    "clang-format",
    "shfmt",
    -- Spell-check.
    "harper_ls",
    "codespell",
  },
})

-- Formatting.
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt", "shellcheck" },
    cpp = { "clang-format" },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
})

-- LSP / Autocomplete / Snippets.
require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})
require("luasnip").setup()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets/" } })
require("blink.cmp").setup({
  snippets = { preset = "luasnip" },
  sources = {
    default = { "snippets", "lsp", "path", "lazydev" },
    providers = {
      lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
    },
  },
  completion = {
    list = { selection = { preselect = false } },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
  },
  signature = { enabled = true },
  cmdline = { enabled = false },
  keymap = {
    ["<C-l>"] = { "snippet_forward", "fallback" },
    ["<C-h>"] = { "snippet_backward", "fallback" },
  },
})
vim.keymap.set({ "s" }, "<C-j>", function()
  require("luasnip").change_choice(1)
end)
vim.keymap.set({ "s" }, "<C-k>", function()
  require("luasnip").change_choice(-1)
end)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("grd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "user-lsp-highlight", buffer = event2.buf })
        end,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, "[T]oggle Inlay [H]ints")
    end
  end,
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
require("mason-lspconfig").setup({
  ensure_installed = {}, -- explicitly set to an empty table (populate via mason-tool-installer)
  automatic_installation = false,
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup(capabilities)
    end,
  },
})

-- Diagnostic Config.
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

-- Fuzzy Finder.
require("fzf-lua").register_ui_select()
vim.keymap.set("n", "<leader><leader>", function()
  require("fzf-lua").global()
end)
vim.keymap.set("n", "<leader>fb", function()
  require("fzf-lua").buffers()
end)

-- Git.
require("gitsigns").setup({
  worktrees = {
    {
      toplevel = vim.env.HOME,
      gitdir = vim.env.HOME .. "/.cfg",
    },
  },
  on_attach = function(bufnr)
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        require("gitsigns").nav_hunk("next")
      end
    end, { buffer = bufnr })
    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        require("gitsigns").nav_hunk("prev")
      end
    end, { buffer = bufnr })
  end,
})

-- vim: ts=2 sts=2 sw=2 et
