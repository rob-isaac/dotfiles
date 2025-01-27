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
vim.g.format_on_save = true

vim.o.termguicolors = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.scrolloff = 3
vim.o.sidescrolloff = 3
vim.o.textwidth = 100
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
vim.o.grepprg = "rg --vimgrep"

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
vim.keymap.set("i", "<C-l>", "<nop>", { desc = "Ignore CTRL-L" })
vim.keymap.set("i", "<C-h>", "<nop>", { desc = "Ignore CTRL-h" })

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

vim.keymap.set("n", "yoe", function()
  if vim.g.diagnostic_severity then
    vim.g.diagnostic_severity = nil
  else
    vim.g.diagnostic_severity = vim.diagnostic.severity.ERROR
  end
end, { desc = "Toggle Diagnostic Severity" })
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

-- NOTE: this is mapping Ctrl-/
vim.keymap.set("v", "<C-_>", [[<esc>/\%V]], { desc = "Search within visual selection" })

vim.keymap.set("n", "gp", "'[v']", { desc = "Visual select pasted text" })

vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "tabonly" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "tabclose" })
vim.keymap.set("n", "<leader>tg", "<cmd>tab Git<cr>", { desc = "Open git in new tab" })

vim.keymap.set("n", "<leader>ds", function()
  vim.fn.histdel("search", -1)
  vim.fn.setreg("/", vim.fn.histget("search", -1))
end, { desc = "Delete the last search pattern" })

vim.keymap.set("i", "<C-s>", "<C-g>u<esc>[s1z=`]a<C-g>u", { desc = "Correct last misspelling" })

vim.keymap.set("n", "]<Space>", [[:<C-u>put =repeat(nr2char(10),v:count)<Bar>execute "'[-1"<cr>]],
  { desc = "Insert blank line below" })
vim.keymap.set("n", "[<Space>", [[:<C-u>put!=repeat(nr2char(10),v:count)<Bar>execute "']+1"<cr>]],
  { desc = "Insert blank line above" })

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
-- Plugin Manager                                                             --
--------------------------------------------------------------------------------

local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end
require('mini.deps').setup({ path = { package = path_package } })

--------------------------------------------------------------------------------
-- Plugins                                                                    --
--------------------------------------------------------------------------------

MiniDeps.add({
  source = "saghen/blink.cmp",
  checkout = "v0.11.0",
})
MiniDeps.add({ source = 'neovim/nvim-lspconfig' })
MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})
MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter-textobjects' })
MiniDeps.add({ source = "stevearc/conform.nvim" })
MiniDeps.add({ source = "MagicDuck/grug-far.nvim" })
MiniDeps.add({ source = "ibhagwan/fzf-lua" })
MiniDeps.add({ source = "rebelot/kanagawa.nvim" })
MiniDeps.add({ source = "Bekaboo/dropbar.nvim" })
MiniDeps.add({ source = "danymat/neogen" })
MiniDeps.add({ source = "stevearc/oil.nvim" })
MiniDeps.add({ source = "folke/lazydev.nvim" })
MiniDeps.add({ source = "j-hui/fidget.nvim" })
MiniDeps.add({ source = "tpope/vim-dispatch" })
MiniDeps.add({ source = "tpope/vim-fugitive" })
MiniDeps.add({ source = "stevearc/aerial.nvim" })
MiniDeps.add({ source = "chentoast/marks.nvim" })
-- TODO: milanglacier/minuet-ai.nvim

require("mini.ai").setup()
require("mini.align").setup()
require("mini.bufremove").setup()
require("mini.cursorword").setup()
require("mini.diff").setup()
require("mini.icons").setup()
require("mini.indentscope").setup()
require("mini.jump").setup()
require("mini.move").setup()
require("mini.operators").setup()
require("mini.pairs").setup()
require("mini.splitjoin").setup()
require("mini.statusline").setup()
require("mini.surround").setup()
require("mini.trailspace").setup()
require("fidget").setup({})
require("grug-far").setup()
require("aerial").setup()
require("marks").setup()

-- [[ LSP ]]

require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library" },
  },
})
local lspconfig = require("lspconfig")
local servers = {
  clangd = { cmd = { "clangd", "--header-insertion=never" } },
  lua_ls = {},
  rust_analyzer = {
    settings = { ["rust-analyzer"] = { completion = { autoimport = { enable = false } } } },
  },
}
for server, settings in pairs(servers) do
  settings.capabilities = require('blink.cmp').get_lsp_capabilities()
  lspconfig[server].setup(settings)
end
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
  end,
})

-- [[ Completion ]]

require("blink.cmp").setup({
  signature = { enabled = true, window = { show_documentation = true } },
  completion = { documentation = { auto_show = true, auto_show_delay_ms = 500 }, list = { selection = { preselect = false } } },
  keymap = {
    ["<C-l>"] = { 'snippet_forward', 'fallback' },
    ["<C-h>"] = { 'snippet_backward', 'fallback' },
    cmdline = {
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
    }
  }
})

-- [[ Fuzzy Finder ]]

require("fzf-lua").setup()
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
  if not vim.g.format_on_save then
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

-- [[ Docs Generation ]]

local neogen_item = require("neogen.types.template").item
local cpp_annotation_convention = {
  { nil,                   "/// @file $1",     { no_results = true, type = { "file" } } },
  { nil,                   "/// $1",           { no_results = true, type = { "func", "file", "class" } } },
  { nil,                   "",                 { no_results = true, type = { "file" } } },
  { neogen_item.ClassName, "/// @class %s",    { type = { "class" } } },
  { neogen_item.Type,      "/// @typedef %s",  { type = { "type" } } },
  { nil,                   "/// $1",           { type = { "func", "class", "type" } } },
  { nil,                   "///",              { no_results = true, type = { "func", "class", "type" } } },
  { neogen_item.Tparam,    "/// @tparam %s $1" },
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

-- [[ File Explorer ]]

require("oil").setup()
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open Explorer" })
