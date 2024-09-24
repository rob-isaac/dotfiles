--------------------------------------------------------------------------------
-- Global Options                                                             --
--------------------------------------------------------------------------------

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.diagnostic_severity = vim.diagnostic.severity.ERROR
vim.g.autoformat = true

vim.o.termguicolors = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.scrolloff = 3
vim.o.sidescrolloff = 3
vim.o.textwidth = 80
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.list = true
vim.o.cursorline = true
vim.o.spell = true
vim.o.spelllang = "en_us"
vim.o.laststatus = 3
vim.o.equalalways = true
vim.o.pumblend = 10
vim.o.title = true
vim.o.undofile = true
vim.o.completeopt = "menuone,popup"
vim.o.pumheight = 10
vim.o.pumwidth = 20
vim.o.infercase = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.wildignorecase = true
vim.o.wildignore = "build/**,*.o,*.obj"
vim.o.wildmenu = true
vim.o.updatetime = 250
vim.o.timeoutlen = 1000
vim.o.inccommand = "split"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.signcolumn = "yes"
vim.o.autoread = true
vim.o.hidden = true
vim.o.confirm = true
vim.o.lazyredraw = true

vim.opt.diffopt:append("vertical")
vim.opt.diffopt:append("indent-heuristic")
vim.opt.diffopt:append("linematch:60")
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.listchars:append("tab:<->")
vim.opt.listchars:append("trail:-")
vim.opt.comments:append(":///")

--------------------------------------------------------------------------------
-- Basic Mappings / Commands / Autocommands / Abbreviations                   --
--------------------------------------------------------------------------------

vim.keymap.set("i", "jj", "<esc>", { desc = "Quick Escape" })
vim.keymap.set("i", "jk", "<esc>", { desc = "Quick Escape" })
vim.keymap.set("i", "<C-r>?", "<C-o>:reg<cr>", { desc = "Peek Registers" })

vim.keymap.set("c", "<C-p>", "<up>", { desc = "Scroll History" })
vim.keymap.set("c", "<C-n>", "<down>", { desc = "Scroll History" })
vim.keymap.set("c", "<C-k>", "<up>", { desc = "Scroll History" })
vim.keymap.set("c", "<C-j>", "<down>", { desc = "Scroll History" })
vim.keymap.set("c", "<C-h>", "<left>", { desc = "Quick Move Left" })
vim.keymap.set("c", "<C-l>", "<right>", { desc = "Quick Move Right" })

vim.keymap.set("n", "<C-s>", "<cmd>update<cr>", { desc = "Save file" })
vim.keymap.set("n", "<esc>", "<cmd>noh<cr>", { desc = "Clear Highlights" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move To Window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move To Window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move To Window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move To Window" })

vim.keymap.set("n", "]oe", function()
  vim.g.diagnostic_severity = vim.diagnostic.severity.ERROR
end, { desc = "Set Error Diagnostic Severity" })
vim.keymap.set("n", "[oe", function()
  vim.g.diagnostic_severity = nil
end, { desc = "Unset Diagnostic Severity" })
vim.keymap.set("n", "yoe", function()
  if vim.g.diagnostic_severity then
    vim.g.diagnostic_severity = nil
  else
    vim.g.diagnostic_severity = vim.diagnostic.severity.ERROR
  end
end, { desc = "Toggle Diagnostic Severity" })

vim.keymap.set("n", "]of", function()
  vim.g.format_on_save = true
end, { desc = "Set Format On Save" })
vim.keymap.set("n", "[of", function()
  vim.g.format_on_save = false
end, { desc = "Unset Format On Save" })
vim.keymap.set("n", "yof", function()
  vim.g.format_on_save = not vim.g.format_on_save
end, { desc = "Toggle Format On Save" })

vim.keymap.set("n", "]d", function()
  vim.diagnostic.goto_next({ severity = vim.g.diagnostic_severity })
end, { desc = "Next error" })
vim.keymap.set("n", "[d", function()
  vim.diagnostic.goto_prev({ severity = vim.g.diagnostic_severity })
end, { desc = "Prev error" })

vim.keymap.set("n", "}", "<cmd>keepjumps normal! }<cr>", { desc = "No Jumplist on }" })
vim.keymap.set("n", "{", "<cmd>keepjumps normal! {<cr>", { desc = "No Jumplist on {" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

for _, k in ipairs({ ",", ".", ";" }) do
  vim.keymap.set("i", k, k .. "<c-g>u", { desc = "Add undo break-point" })
end
vim.keymap.set("i", "<C-u>", "<c-g>u<c-u>", { desc = "Add undo break-point" })

vim.keymap.set("n", "<leader>ql", function()
  local session_dir = vim.fn.stdpath("data") .. "/sessions"
  local pwd = vim.fn.getcwd()
  if not pwd or pwd == "" then
    vim.notify("FAILED TO LOAD SESSION", vim.log.levels.ERROR)
    return
  end
  local session_name = string.gsub(pwd, "/", "%%")
  -- TODO: can incorporate the git branch as well
  vim.cmd("source " .. vim.fn.fnameescape(session_dir .. "/" .. session_name))
end, { desc = "Load session" })

vim.api.nvim_create_user_command("ConfigEdit", "e $MYVIMRC", { desc = "Edit Config File" })
vim.api.nvim_create_user_command(
  "Gcheck",
  "cexpr system('git diff --check')",
  { desc = "Load results from 'git diff --check' into quickfix" }
)

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight on Yank",
})
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
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("auto_hide_cursorline", {}),
  callback = function()
    local cursorline_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local match = win == cursorline_win
      vim.api.nvim_set_option_value("cursorline", match, { win = win })
    end
  end,
  desc = "Only display cursorline for the active window",
})
vim.api.nvim_create_autocmd({ "Filetype" }, {
  group = vim.api.nvim_create_augroup("disable_spelling", {}),
  pattern = { "help", "qf", "man", "checkhealth" },
  callback = function(args)
    vim.api.nvim_set_option_value("spell", false, { win = args.win })
  end,
  desc = "Disable Spell",
})
vim.api.nvim_create_autocmd("ExitPre", {
  group = vim.api.nvim_create_augroup("save_session", {}),
  callback = function()
    local session_dir = vim.fn.stdpath("data") .. "/sessions"
    vim.fn.mkdir(session_dir, "p")
    local pwd = vim.fn.getcwd()
    if not pwd or pwd == "" then
      vim.notify("FAILED TO SAVE SESSION", vim.log.levels.ERROR)
      return
    end
    local session_name = string.gsub(pwd, "/", "%%")
    -- TODO: can incorporate the git branch as well
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_dir .. "/" .. session_name))
  end,
  desc = "save session on exit",
})

vim.cmd([[cabbr h vert help]])
vim.cmd([[cabbr Man vert Man]])
vim.cmd([[cabbr copen botright copen]])

--------------------------------------------------------------------------------
-- Lazy.nvim (Plugin Manager)                                                --
--------------------------------------------------------------------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Classic vim plugins
    "tpope/vim-surround",
    "tpope/vim-projectionist",
    "tpope/vim-sensible",
    "tpope/vim-unimpaired",
    "tpope/vim-abolish",
    "tpope/vim-dispatch",
    "tpope/vim-repeat",
    "tpope/vim-vinegar",
    "tpope/vim-sleuth",
    "tpope/vim-eunuch",
    "tpope/vim-speeddating",
    "tpope/vim-fugitive",

    -- LSP
    { "folke/neodev.nvim", opts = {} },
    "neovim/nvim-lspconfig",

    -- Completion / Snippets
    { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
    { "danymat/neogen", version = "*" },
    { "windwp/nvim-autopairs", opts = { fast_wrap = { map = "<C-g>w" } } },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/nvim-cmp",

    -- Treesitter
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    "nvim-treesitter/nvim-treesitter-textobjects",

    -- Statusline
    "nvim-lualine/lualine.nvim",
    "SmiteshP/nvim-navic",
    "arkav/lualine-lsp-progress",

    -- Misc
    "ibhagwan/fzf-lua",
    "lewis6991/gitsigns.nvim",
    "sainnhe/gruvbox-material",
    "nvim-tree/nvim-web-devicons",
    "stevearc/conform.nvim",
    { "folke/trouble.nvim", opts = {} },
    { "williamboman/mason.nvim", opts = {} },
    { "cshuaimin/ssr.nvim", opts = {} },
    { "stevearc/aerial.nvim", opts = {} },
    { "chentoast/marks.nvim", event = "VeryLazy", opts = {} },
  },
  checker = { enabled = false },
  rocks = { enabled = false },
})

--------------------------------------------------------------------------------
-- Plugins                                                                    --
--------------------------------------------------------------------------------

-- [[ Colorscheme ]]

vim.g.gruvbox_material_foreground = "mix"
vim.g.gruvbox_material_enable_italic = true
vim.cmd.colorscheme("gruvbox-material")

-- [[ Vim Plugins ]]

vim.g.dispatch_compilers = { ninja = "gcc" }
vim.g.netrw_sort_sequence = [[[\/]$,*,\%(\.bak\|\~\|\.o\|\.info\|\.swp\|\.obj\)[*@]\=$]]

-- [[ Fuzzy-Finder ]]

vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep_glob<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Find Buffer" })
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua grep_cword<cr>", { desc = "Grep Word" })
vim.keymap.set("n", "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", { desc = "Grep WORD" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua lgrep_curbuf<cr>", { desc = "Grep Visual Selection" })
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Find Document Diagnostics" })
vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Find Workspace Diagnostics" })
vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua lsp_references<cr>", { desc = "Find References" })
vim.keymap.set("n", "<leader>fR", "<cmd>FzfLua resume<cr>", { desc = "Resume Last Find" })

vim.keymap.set("v", "<leader>f", "<cmd>FzfLua grep_visual<cr>", { desc = "Grep Visual Selection" })

require("fzf-lua").register_ui_select()

-- [[ Git Sign Column ]]

require("gitsigns").setup({
  worktrees = {
    {
      toplevel = vim.env.HOME,
      gitdir = vim.env.HOME .. "/.dotfiles",
    },
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns")
    vim.keymap.set("n", "]h", gitsigns.next_hunk, { buffer = bufnr, desc = "hunk forward" })
    vim.keymap.set("n", "[h", gitsigns.prev_hunk, { buffer = bufnr, desc = "hunk backward" })
    vim.keymap.set({ "n", "v" }, "<leader>gp", gitsigns.preview_hunk, { buffer = bufnr, desc = "preview hunk" })
    vim.keymap.set({ "n", "v" }, "<leader>gs", gitsigns.stage_hunk, { buffer = bufnr, desc = "stage hunk" })
    vim.keymap.set({ "n", "v" }, "<leader>gu", gitsigns.undo_stage_hunk, { buffer = bufnr, desc = "stage hunk" })
    vim.keymap.set({ "n", "v" }, "<leader>gr", gitsigns.reset_hunk, { buffer = bufnr, desc = "reset hunk" })
    vim.keymap.set({ "n", "v" }, "<leader>gb", gitsigns.blame_line, { buffer = bufnr, desc = "blame line" })
  end,
})

-- [[ Treesitter ]]

---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "cpp", "comment", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
  highlight = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
      },
      selection_modes = {
        ["@function.outer"] = "V",
        ["@function.inner"] = "V",
        ["@class.outer"] = "V",
        ["@class.inner"] = "V",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
        [">a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
        ["<a"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = { query = "@function.outer", desc = "Next function start" },
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[["] = "@class.outer",
        ["[z"] = { query = "@fold", query_group = "folds", desc = "Prev fold" },
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
})

-- [[ Formatting ]]

local function format()
  if not vim.g.autoformat then
    return
  end
  require("conform").format({
    lsp_format = "fallback",
    timeout_ms = 500,
  })
end

require("conform").setup({
  notify_on_error = true,
  format_on_save = format,
  formatters_by_ft = {
    lua = { "stylua" },
    cpp = { "clang_format" },
  },
})
vim.keymap.set("n", "<leader>cf", format, { desc = "Code Format" })

-- [[ LSP / Completion ]]

local lspconfig = require("lspconfig")
local ls = require("luasnip")
local cmp = require("cmp")

vim.api.nvim_create_user_command("SnippetEdit", function()
  require("luasnip.loaders").edit_snippet_files()
end, { desc = "Edit Config File" })

---@diagnostic disable-next-line: assign-type-mismatch
require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets" })
ls.config.setup({})

local function pad_or_truncate(s, l)
  if not s then
    return string.rep(" ", l)
  end
  if s:len() < l then
    return s .. string.rep(" ", l - s:len())
  else
    return string.sub(s, 1, l - 3) .. "..."
  end
end

cmp.setup({
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end,
  },
  completion = { completeopt = "menuone,preview,noselect" },
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, item)
      item.abbr = pad_or_truncate(item.abbr, 25)
      item.menu = ({
        nvim_lsp = " [LSP]",
        luasnip = "[SNIP]",
        buffer = " [BUF]",
        path = "[PATH]",
      })[entry.source.name]
      return item
    end,
    expandable_indicator = true,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-y>"] = function()
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        cmp.complete({})
      end
    end,
    ["<C-l>"] = cmp.mapping(function(fallback)
      if ls.expand_or_locally_jumpable() then
        ls.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-h>"] = cmp.mapping(function(fallback)
      if ls.locally_jumpable(-1) then
        ls.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function(fallback)
      if ls.choice_active() then
        ls.change_choice(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    -- NOTE: using C-k for signature help so don't want to clobber
  }),
  sources = {
    { name = "luasnip" },
    {
      name = "nvim_lsp",
      entry_filter = function(entry)
        return entry:get_kind() ~= require("cmp").lsp.CompletionItemKind.Snippet
          and entry:get_kind() ~= require("cmp").lsp.CompletionItemKind.Text
      end,
    },
    { name = "path" },
    { name = "buffer" },
  },
  ---@diagnostic disable-next-line: missing-fields
  sorting = {
    comparators = {
      cmp.config.compare.score,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      -- NOTE: the builtin scopes comparator is very slow - do not use

      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find("^_+")
        local _, entry2_under = entry2.completion_item.label:find("^_+")
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", {}),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", "<cmd>FzfLua lsp_definitions<cr>", "[G]oto [D]efinition")
    map("gD", "<cmd>FzfLua lsp_declarations<cr>", "[G]oto [D]eclaration")
    map("gr", "<cmd>FzfLua lsp_references<cr>", "[G]oto [R]eferences")
    map("gI", "<cmd>FzfLua lsp_implementations<cr>", "[G]oto [I]mplementation")

    map("<leader>cs", "<cmd>FzfLua lsp_document_symbols<cr>", "[C]ode [S]ymbols (Buffer)")
    map("<leader>cS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", "[C]ode [S]ymbols (Workspace)")
    map("<Leader>cI", "<cmd>FzfLua lsp_incoming_calls<cr>", "[C]ode [I]ncoming calls")
    map("<Leader>co", "<cmd>FzfLua lsp_outgoing_calls<cr>", "[C]ode [O]utgoing calls")
    map("<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", "[C]ode [A]ction")
    map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
    map("<leader>ct", "<cmd>FzfLua lsp_typedefs<cr>", "Goto [T]ype Definition")

    map("K", vim.lsp.buf.hover, "Hover")
    vim.keymap.set(
      { "i", "s" },
      "<C-k>",
      vim.lsp.buf.signature_help,
      { buffer = event.buf, desc = "LSP: Signature Help" }
    )

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    require("nvim-navic").attach(client, event.buf)
  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

_G.signature_handler_offset = 0
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertCharPre" }, {
  group = vim.api.nvim_create_augroup("reset_signature_handler_offset", {}),
  callback = function()
    _G.signature_handler_offset = 0
  end,
  desc = "reset signature handler offset on events that would close the signature help window",
})
local signature_help = function(_, result, ctx, config)
  result = result or {}
  local num_signatures = math.max(#(result.signatures or {}), 1)
  result.activeSignature = math.fmod((result.activeSignature or 0) + _G.signature_handler_offset, num_signatures)
  _G.signature_handler_offset = _G.signature_handler_offset + 1
  config = config or {}
  config.focus = false
  vim.lsp.handlers.signature_help(_, result, ctx, config)
end

local servers = {
  clangd = { cmd = { "clangd", "--header-insertion=never" } },
  lua_ls = {},
  rust_analyzer = {
    settings = { ["rust-analyzer"] = { completion = { autoimport = { enable = false } } } },
  },
}

for server, settings in pairs(servers) do
  lspconfig[server].setup(
    vim.tbl_deep_extend(
      "force",
      { capabilities = capabilities, handlers = { ["textDocument/signatureHelp"] = signature_help } },
      settings
    )
  )
end

-- [[ Statusline ]]

require("lualine").setup({
  sections = {
    lualine_c = {
      "filename",
      "navic",
      "lsp_progress",
    },
  },
})

-- [[ Docs Generation ]]

local neogen_item = require("neogen.types.template").item
local cpp_annotation_convention = {
  { nil, "/// @file", { no_results = true, type = { "file" } } },
  { nil, "/// @brief $1", { no_results = true, type = { "func", "file", "class" } } },
  { nil, "", { no_results = true, type = { "file" } } },
  { neogen_item.ClassName, "/// @class %s", { type = { "class" } } },
  { neogen_item.Type, "/// @typedef %s", { type = { "type" } } },
  { nil, "/// @brief $1", { type = { "func", "class", "type" } } },
  { neogen_item.Tparam, "/// @tparam %s $1" },
  { neogen_item.Parameter, "/// @param %s $1" },
}
require("neogen").setup({
  snippet_engine = "luasnip",
  languages = {
    cpp = {
      template = {
        annotation_convention = "cpp_annotation_convention",
        cpp_annotation_convention = cpp_annotation_convention,
      },
    },
  },
})
