--------------------------------------------------------------------------------
-- Global Options                                                             --
--------------------------------------------------------------------------------

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.termguicolors = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.smartcase = true
vim.o.ignorecase = true
vim.o.scrolloff = 3
vim.o.sidescrolloff = 3
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.cmdheight = 0
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
vim.o.grepprg = "rg --vimgrep"
vim.o.gdefault = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.inccommand = "split"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.signcolumn = "yes"

--------------------------------------------------------------------------------
-- Colorscheme                                                                --
--------------------------------------------------------------------------------

vim.cmd([[colorscheme retrobox]])

--------------------------------------------------------------------------------
-- Helper Functions                                                           --
--------------------------------------------------------------------------------

local function save_session()
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
end

local function load_session()
  local session_dir = vim.fn.stdpath("data") .. "/sessions"
  local pwd = vim.fn.getcwd()
  if not pwd or pwd == "" then
    vim.notify("FAILED TO LOAD SESSION", vim.log.levels.ERROR)
    return
  end
  local session_name = string.gsub(pwd, "/", "%%")
  -- TODO: can incorporate the git branch as well
  vim.cmd("source " .. vim.fn.fnameescape(session_dir .. "/" .. session_name))
end

--------------------------------------------------------------------------------
-- Mappings                                                                   --
--------------------------------------------------------------------------------

local map = vim.keymap.set

-- Misc mappings
for _, k in ipairs({ "h", "j", "k", "l" }) do
  map("n", "<C-" .. k .. ">", "<C-w>" .. k, { desc = "Move Window" })
end

for _, k in ipairs({ ",", ".", ";" }) do
  map("i", k, k .. "<c-g>u", { desc = "Add undo break-point" })
end
map("i", "<C-u>", "<c-g>u<c-u>", { desc = "Add undo break-point" })

map("i", "jk", "<Esc>", { desc = "Quick Escape" })
map("i", "jj", "<Esc>", { desc = "Quick Escape" })

map("n", "j", "gj", { desc = "visual move line" })
map("n", "k", "gk", { desc = "visual move line" })

map({ "i", "c" }, "<C-l>", "<right>", { desc = "quick move right" })
map({ "i", "c" }, "<C-h>", "<left>", { desc = "quick move left" })

map("c", "<C-k>", "<Up>", { desc = "Earlier Command" })
map("c", "<C-j>", "<Down>", { desc = "Later Command" })

map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

map("n", "}", "<cmd>keepjumps normal! }<cr>", { desc = "No Jumplist on }" })
map("n", "{", "<cmd>keepjumps normal! {<cr>", { desc = "No Jumplist on {" })

map("n", "-", "<cmd>e %:p:h<cr>", { desc = "Open File Explorer" })
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear Highlights" })
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save Buffer" })
map({ "n", "v" }, "<Space>", "<Nop>", { desc = "Do nothing on spacabar" })

-- Bracket mappings
map("n", "]<Space>", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, cur_line, cur_line, true, { "" })
end, { desc = "Insert line below" })
map("n", "[<Space>", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(0, cur_line, cur_line, true, { "" })
end, { desc = "Insert line above" })
map("n", "]q", "<cmd>silent cnext<cr>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>silent cprev<cr>", { desc = "Prev quickfix" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
map("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Prev error" })

-- Leader mappings
map("n", "<leader>ql", load_session, { desc = "Load session" })
map("n", "<leader>qs", save_session, { desc = "Save session" })
map("n", "<leader>qq", "<cmd>wqa<cr>", { desc = "Quick quit" })
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Quickfix open" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Quickfix close" })

--------------------------------------------------------------------------------
-- Abbreviations                                                              --
--------------------------------------------------------------------------------

vim.cmd([[cabbr h vert help]])
vim.cmd([[cabbr Man vert Man]])
vim.cmd([[cabbr bd bp<bar>sp<bar>bn<bar>bd]])

--------------------------------------------------------------------------------
-- Autocommands                                                               --
--------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "help", "vim", "qf", "man" },
  group = vim.api.nvim_create_augroup("Close With Q", {}),
  callback = function(args)
    map("n", "q", "<cmd>close<cr>", { buffer = args.buf })
  end,
  desc = "Close With 'q'",
})
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 100 })
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
vim.api.nvim_create_autocmd("ExitPre", {
  group = vim.api.nvim_create_augroup("save_session", {}),
  callback = save_session,
  desc = "save session on exit",
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
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    map("n", "<leader>cr", function()
      vim.lsp.buf.rename()
    end, { desc = "Code Rename" })
    map("n", "<leader>cf", function()
      vim.lsp.buf.format({
        filter = function(client)
          return client.name == "null-ls"
        end,
      })
    end, { desc = "Code Format" })
    map("n", "<leader>cd", function()
      vim.lsp.buf.definition()
    end, { desc = "Code Definition" })
    map("n", "<leader>cD", function()
      vim.lsp.buf.declaration()
    end, { desc = "Code Declaration" })
    map("n", "<leader>ch", function()
      vim.lsp.buf.document_highlight()
    end, { desc = "Code Highlight" })
    map("n", "<leader>cH", function()
      vim.lsp.buf.clear_references()
    end, { desc = "Code Remove Highlight" })
    map("n", "<leader>cs", function()
      vim.lsp.buf.document_symbol()
    end, { desc = "Code Symbols (Document)" })
    map("n", "<leader>cS", function()
      vim.lsp.buf.workspace_symbol()
    end, { desc = "Code Symbols (Workspace)" })
    map("n", "<leader>ci", function()
      vim.lsp.buf.incoming_calls()
    end, { desc = "Code Incoming Calls" })
    map("n", "<leader>co", function()
      vim.lsp.buf.outgoing_calls()
    end, { desc = "Code Outgoing Calls" })
    map("n", "<leader>cI", function()
      vim.lsp.buf.implementation()
    end, { desc = "Code Implementation" })
    map("n", "<leader>cR", function()
      vim.lsp.buf.references()
    end, { desc = "Code References" })
    map("n", "<leader>ct", function()
      vim.lsp.buf.type_definition()
    end, { desc = "Code References" })
    map("n", "<leader>ci", function()
      vim.lsp.inlay_hint.enable()
    end, { desc = "Code Inlay Hints" })
    map("n", "<leader>ca", function()
      vim.lsp.buf.code_action()
    end, { desc = "Code Action" })

    map("i", "<C-k>", function()
      vim.lsp.buf.signature_help()
    end, { desc = "Signature Help" })

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({
          filter = function(client)
            return client.name == "null-ls"
          end,
        })
      end,
      desc = "format on save",
    })
  end,
})

--------------------------------------------------------------------------------
-- User Commands                                                              --
--------------------------------------------------------------------------------

vim.api.nvim_create_user_command(
  "Gcheck",
  "cexpr system('git diff --check')",
  { desc = "Load results from 'git diff --check' into quickfix" }
)

--------------------------------------------------------------------------------
-- Plugins                                                                    --
--------------------------------------------------------------------------------

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
    { import = "plugins" },
  },
  change_detection = { enabled = false },
  rocks = { enabled = false },
})
