-- [[ Options ]]
vim.o.autowriteall = true
vim.o.breakindent = true
vim.o.chistory = 20
vim.o.cmdheight = 0
vim.o.confirm = true
vim.o.diffopt =
  "algorithm:histogram,anchor,closeoff,context:10,closeoff,filler,hiddenoff,internal,indent-heuristic,inline:word,linematch:60"
vim.o.expandtab = true
vim.o.fillchars = "eob: "
vim.o.foldcolumn = "auto:5"
vim.o.grepprg = "rg --vimgrep"
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.jumpoptions = "view"
vim.o.laststatus = 3
vim.o.list = true
vim.o.mouse = "a"
vim.o.pumborder = "rounded"
vim.o.pumheight = 15
vim.o.pummaxwidth = 50
vim.o.pumwidth = 50
vim.o.scrolloff = 3
vim.o.shiftwidth = 2
vim.o.showmode = false
vim.o.sidescrolloff = 5
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.spell = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 2
vim.o.timeoutlen = 800
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.winborder = "rounded"

-- require("vim._core.ui2").enable({})

vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.diffs = {
  integrations = { fugitive = true },
  keymaps = {
    ours = "<leader>co",
    theirs = "<leader>ct",
    both = "<leader>cb",
    none = "<leader>c0",
    next = "]x",
    prev = "[x",
  },
}
vim.g.llama_config = { show_info = 1, enable_at_startup = false }
vim.g.slime_target = "tmux"
vim.g.slime_default_config = { socket_name = "default", target_pane = "{down-of}" }
vim.g.slime_dont_ask_default = 1
vim.g.slime_bracketed_paste = 1

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

vim.keymap.set("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "quick delete tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "quick next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprev<cr>", { desc = "quick prev tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabnew<cr>", { desc = "quick new tab" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "quick new tab" })

vim.keymap.set("n", "<leader>wc", "<C-w>v", { desc = "quick create window" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "quick only window" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "quick horizontal winsplit" })
vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "quick vertical winsplit" })
vim.keymap.set("n", "<leader>wd", "<C-w>v", { desc = "quick close window" })

vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "move window focus" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "move window focus" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "move window focus" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "move window focus" })

vim.keymap.set("n", "<leader>wH", "<C-w>H", { desc = "move window pane" })
vim.keymap.set("n", "<leader>wJ", "<C-w>J", { desc = "move window pane" })
vim.keymap.set("n", "<leader>wK", "<C-w>K", { desc = "move window pane" })
vim.keymap.set("n", "<leader>wL", "<C-w>L", { desc = "move window pane" })
vim.keymap.set("n", "<leader>wr", "<C-w>r", { desc = "rotate window pane" })
vim.keymap.set("n", "<leader>wR", "<C-w>R", { desc = "rotate window pane" })

vim.keymap.set("n", "gp", "`[v`]", { desc = "quick select pasted text" })

-- NOTE: override the insert mappings later for snippet jumping (but this is a good fallback).
vim.keymap.set({ "i", "c" }, "<c-l>", "<right>", { desc = "quick move right" })
vim.keymap.set({ "i", "c" }, "<c-h>", "<left>", { desc = "quick move left" })

-- NOTE: we override this with fzf-lua interface later, but this is good to have if we fail plugins.
vim.keymap.set("n", "<C-]>", "g<C-]>", { desc = "Show list if multiple tag matches" })

vim.keymap.set("n", "<X1Mouse>", "<C-o>", { desc = "Jump back in jumplist" })
vim.keymap.set("n", "<X2Mouse>", "<C-i>", { desc = "Jump forward in jumplist" })

vim.cmd("cabbr tag tjump")
vim.cmd("cabbr h vert h")
vim.cmd("cabbr m vert Man")

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
  "junegunn/vim-easy-align",
  "tpope/vim-abolish",
  "tpope/vim-dispatch",
  "tpope/vim-endwise",
  "tpope/vim-eunuch",
  "tpope/vim-fugitive",
  "tpope/vim-obsession",
  "tpope/vim-projectionist",
  "tpope/vim-repeat",
  "tpope/vim-rhubarb",
  "tpope/vim-rsi",
  "tpope/vim-sleuth",
  "tpope/vim-speeddating",
  "tpope/vim-unimpaired",
  "wellle/targets.vim",
  "romainl/vim-qf",
  "rhysd/committia.vim",
  "rhysd/clever-f.vim",
  "christoomey/vim-tmux-navigator",
  "rob-isaac/terminal-ft.nvim",
  "MagicDuck/grug-far.nvim",
  "stevearc/aerial.nvim",
  "stevearc/stickybuf.nvim",
  "stevearc/quicker.nvim",
  "rob-isaac/alternator.nvim",
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
  "stevearc/conform.nvim",
  "chentoast/marks.nvim",
  "stevearc/oil.nvim",
  "barrettruth/diffs.nvim",
  "jpalardy/vim-slime",
  "windwp/nvim-autopairs",
  "cbochs/grapple.nvim",
  "pwntester/octo.nvim",
  "SmiteshP/nvim-navic",
  "ggml-org/llama.vim",
  { "EdenEast/nightfox.nvim", priority = 1000 },
  { "L3MON4D3/LuaSnip", version = "*", build = "make install_jsregexp" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "saghen/blink.cmp", version = "*" },
  { "esmuellert/codediff.nvim" },
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { "nickjvandyke/opencode.nvim", version = "*" },
  -- { "aymericbeaumet/vim-symlink", dependencies = { "moll/vim-bbye" } },
  -- j-morano/buffer_manager.nvim
  -- "alexpasmantier/pymple.nvim",
  -- ahkohd/difft.nvim
  install = { colorscheme = { "nightfox", "default" } },
  checker = { enabled = false },
  rocks = { enabled = false },
})

-- My configs.
require("autocmds")
require("usercmds")

-- Simple packages.
vim.cmd.packadd("cfilter")
vim.cmd.packadd("nvim.difftool")
vim.cmd.packadd("nvim.undotree")

require("mason").setup()
require("nvim-surround").setup()
require("aerial").setup()
require("stickybuf").setup()
require("marks").setup()
require("grug-far").setup()
require("oil").setup()
require("nvim-autopairs").setup()
require("octo").setup({
  picker = "fzf-lua",
  -- mappings_disable_default = true,
})
require("codecompanion").setup({
  chat = {
    adapter = {
      name = "copilot",
      model = "gpt-5.4",
    },
  },
})
-- require("git-conflict").setup({ default_mappings = false })
require("terminal").setup()
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("terminal-filetype", { clear = true }),
  pattern = "*.log",
  command = "set ft=terminal",
})

vim.keymap.set("n", "ga", "<Plug>(EasyAlign)", { desc = "Easy Align" })
vim.keymap.set("n", "gro", "<cmd>AerialToggle<cr>", { desc = "Toggle Aerial [O]utline" })
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "File Explorer" })

-- UI.
require("nightfox").setup({
  options = {
    transparent = true,
    styles = {
      comments = "italic",
      constants = "bold",
      functions = "bold",
      keywords = "bold",
      strings = "italic",
      types = "italic,bold",
    },
  },
})
vim.cmd.colorscheme("nightfox")

local navic = require("nvim-navic")
require("lualine").setup({
  sections = {
    lualine_b = {
      "branch",
      "diff",
      function()
        if vim.fn.search("^<<<<<<<", "nw") ~= 0 then
          return "⚠️"
        end
        return ""
      end,
      "diagnostics",
    },
    lualine_c = {
      { "filename", path = 1, shortening_target = 30 },
      "navic",
      "lsp_status",
      function()
        return vim.g.ai_enabled and "🤖" or ""
      end,
    },
    lualine_x = {
      function()
        return vim.fn["ObsessionStatus"]("Tracking Session", "")
      end,
      "encoding",
      "fileformat",
      "filetype",
    },
    lualine_y = {
      "progress",
      "searchcount",
      "selectioncount",
    },
  },
})
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, ev.buf)
    end
  end,
})

-- Tool Installer.
local tool_list = {
  -- Language servers.
  "lua_ls",
  "clangd",
  "bashls",
  "jsonls",
  "fish_lsp",
  "rust-analyzer",
  "buf",
  -- "pyright",
  -- "pyrefly",
  "basedpyright",
  -- "ty",
  -- Formatters.
  "stylua",
  "clang-format",
  "shfmt",
  "ruff",
  -- "mdformat",
  -- Spell-check.
  "harper_ls",
  "codespell",
}
local ensure_installed_tool_list = {
  -- Language servers.
  "lua_ls",
  "clangd",
  "bashls",
  "jsonls",
  "fish_lsp",
  "rust-analyzer",
  "buf",
  -- "pyright",
  -- "pyrefly",
  "basedpyright",
  -- "ty",
  -- Formatters.
  "stylua",
  "clang-format",
  "shfmt",
  "ruff",
  -- "mdformat",
  -- Spell-check.
  "harper_ls",
  "codespell",
}
require("mason-tool-installer").setup({
  ensure_installed = ensure_installed_tool_list,
})

-- Formatting.
vim.g.format_on_save = true
vim.keymap.set("n", "yof", function()
  vim.g.format_on_save = not vim.g.format_on_save
end, { desc = "Toggle Format on Save" })
vim.keymap.set("n", "grf", function()
  require("conform").format()
end, { desc = "Format Buffer" })
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt", "shellcheck" },
    cpp = { "clang-format" },
    python = { "ruff_organize_imports", "ruff_format" },
    -- markdown = { "mdformat" },
  },
  format_on_save = function()
    if vim.g.format_on_save == false then
      return nil
    end
    return {
      lsp_format = "fallback",
      timeout_ms = 500,
    }
  end,
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
      map("yoh", function()
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
  underline = { severity = { min = vim.diagnostic.severity.ERROR } },
  virtual_text = true,
  virtual_lines = false,
  jump = { float = true },
})

-- Fuzzy Finder.
require("fzf-lua").setup({
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
})
require("fzf-lua").register_ui_select()
vim.keymap.set("n", "<leader><leader>", function()
  require("fzf-lua").global()
end)
vim.keymap.set("n", "<leader>,", function()
  require("fzf-lua").buffers()
end)
vim.keymap.set("n", "<leader>/", function()
  require("fzf-lua").lgrep_curbuf()
end)
vim.keymap.set("n", "<leader>fg", function()
  require("fzf-lua").git_status()
end)
vim.keymap.set("n", "<leader>ff", function()
  require("fzf-lua").files()
end)
vim.keymap.set("n", "<leader>fj", function()
  require("fzf-lua").jumps()
end)
vim.keymap.set("n", "<leader>fm", function()
  require("fzf-lua").marks()
end)
vim.keymap.set("n", "<leader>fr", function()
  require("fzf-lua").resume()
end)
vim.keymap.set("n", "<leader>fs", function()
  require("fzf-lua").live_grep()
end)
vim.keymap.set("n", "<leader>fu", function()
  require("fzf-lua").undotree()
end)
vim.keymap.set("n", "<leader>fw", function()
  require("fzf-lua").grep_cword()
end)
vim.keymap.set("n", "<leader>fq", function()
  require("fzf-lua").quickfix()
end)
vim.keymap.set("n", "<leader>fo", function()
  require("fzf-lua").oldfiles()
end)
vim.keymap.set("n", "<c-]>", function()
  require("fzf-lua").lsp_definitions()
end)
vim.keymap.set("i", "<C-x><C-l>", function()
  require("fzf-lua").complete_line()
end)
vim.keymap.set("i", "<C-x><C-f>", function()
  require("fzf-lua").complete_file()
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

    vim.keymap.set("v", "<leader>gs", function()
      require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { buffer = bufnr, desc = "git [s]tage hunk" })
    vim.keymap.set("v", "<leader>gr", function()
      require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { buffer = bufnr, desc = "git [r]eset hunk" })
    vim.keymap.set("n", "<leader>gs", require("gitsigns").stage_hunk, { buffer = bufnr, desc = "git [s]tage hunk" })
    vim.keymap.set("n", "<leader>gr", require("gitsigns").reset_hunk, { buffer = bufnr, desc = "git [r]eset hunk" })
    vim.keymap.set("n", "<leader>gS", require("gitsigns").stage_buffer, { buffer = bufnr, desc = "git [S]tage buffer" })
    vim.keymap.set(
      "n",
      "<leader>gu",
      require("gitsigns").stage_hunk,
      { buffer = bufnr, desc = "git [u]ndo stage hunk" }
    )
    vim.keymap.set("n", "<leader>gR", require("gitsigns").reset_buffer, { buffer = bufnr, desc = "git [R]eset buffer" })
    vim.keymap.set("n", "<leader>gp", require("gitsigns").preview_hunk, { buffer = bufnr, desc = "git [p]review hunk" })
    vim.keymap.set("n", "<leader>gb", require("gitsigns").blame_line, { buffer = bufnr, desc = "git [b]lame line" })
    vim.keymap.set(
      "n",
      "<leader>gd",
      require("gitsigns").diffthis,
      { buffer = bufnr, desc = "git [d]iff against index" }
    )
    vim.keymap.set("n", "<leader>gD", function()
      require("gitsigns").diffthis("@")
    end, { buffer = bufnr, desc = "git [D]iff against last commit" })
  end,
})

-- Treesitter.
local ts_filetypes = {
  "bash",
  "c",
  "comment",
  "cpp",
  "diff",
  "fish",
  "gitcommit",
  "html",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}
require("nvim-treesitter").install(ts_filetypes)
require("treesitter-context").setup({ mode = "topline", max_lines = 3 })
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)

    if not language or not vim.treesitter.language.add(language) then
      return
    end
    vim.treesitter.start(buf, language)

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

vim.keymap.set({ "x", "o" }, "am", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "as", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end)

vim.keymap.set("n", "<leader>a", function()
  require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
end)
vim.keymap.set("n", "<leader>A", function()
  require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
end)

vim.keymap.set({ "n", "x", "o" }, "]m", function()
  require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]]", function()
  require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]o", function()
  require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]M", function()
  require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "][", function()
  require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
end)

vim.keymap.set({ "n", "x", "o" }, "[m", function()
  require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[]", function()
  require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[o", function()
  require("nvim-treesitter-textobjects.move").goto_previous_start({ "@loop.inner", "@loop.outer" }, "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[M", function()
  require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[[", function()
  require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
end)

local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

-- Alternator.
local alternator_transformations = {
  {
    pattern = "(.-)[-_]test%.cpp",
    transformations = {
      test = "%0",
      source = "%1.cpp",
      header = "%1.h",
    },
  },
  {
    pattern = "(.-)%.cpp",
    transformations = {
      test = { "%1-test.cpp", "%1_test.cpp" },
      source = "%0",
      header = "%1.h",
    },
  },
  {
    pattern = "(.-)%.h",
    transformations = {
      test = { "%1-test.cpp", "%1_test.cpp" },
      source = "%1.cpp",
      header = "%0",
    },
  },
}

require("alternator").setup({
  transformations = alternator_transformations,
  mappings = {
    test = "<leader>et",
    header = "<leader>eh",
    source = "<leader>es",
  },
})
vim.keymap.set("n", "<leader>ea", "<cmd>e #<cr>")

-- Quicker.

require("quicker").setup({
  keys = {
    {
      ">",
      function()
        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
      end,
      desc = "Expand quickfix context",
    },
    {
      "<",
      function()
        require("quicker").collapse()
      end,
      desc = "Collapse quickfix context",
    },
  },
})
vim.keymap.set("n", "<leader>q", function()
  require("quicker").toggle()
end, { desc = "Quick Toggle Quickfix List" })
vim.keymap.set("n", "<leader>l", function()
  require("quicker").toggle({ loclist = true })
end, { desc = "Quick Toggle Location List" })

--  AI inline completion
vim.keymap.set("n", "yoa", "<cmd>LlamaToggle<cr>", { desc = "Toggle AI Completion" })

-- Fugitive
-- I'm not sure why but fugitive files are mutable by default with this config.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function(args)
    vim.bo[args.buf].modifiable = false
  end,
})

-- vim: ts=2 sts=2 sw=2 et
