-- TODO: Put capslock/numlock/recording information in the statusline
-- TODO: Pin down sources of conflicting keymaps (indicated in which key health)
-- TODO: setup refreshing files on vimenter, etc
-- TODO: setup a keymap similar to <C-o> but that goes back a file
-- TODO: Fix neovim bug where <C-e> on command line re-pastes the command
-- TODO: add a mapping to live_grep and grep_word telescope pickers to filter by filetype or similarly have a keymap to input a filetype beforehand
-- TODO: Fix the <> marks updating in lua functions during visual mode to allow things like find-word for a visual selection
-- TODO: setup nvim_dap for debugging
-- TODO: "Bekaboo/dropbar.nvim", graple/harpoon, autopairs, telecope-undo
-- TODO: move things into their own subdirectories
-- TODO: performance = { rtp = { disabled_plugins = { "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin", }, }, },
-- TODO: Create snippets
vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.skip_ts_context_commentstring_module = true

vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", eol = "⤶" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 5
vim.opt.hlsearch = true
vim.opt.number = false
vim.opt.spell = true
vim.opt.spelllang = "en_us"
vim.opt.pumblend = 10
vim.opt.winblend = 5
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
vim.opt.foldlevelstart = 99
if vim.fn.executable("fish") then
  vim.opt.shell = "fish"
end

-- [[ Basic Keymaps ]]

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- TODO: go to next error diagnostic with ]e
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error next" })
vim.keymap.set("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Error prev" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<leader>o", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, cur_line, cur_line, true, { "" })
end, { desc = "Insert line below" })
vim.keymap.set("n", "<leader>O", function()
  local cur_line = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(0, cur_line, cur_line, true, { "" })
end, { desc = "Insert line above" })

-- TODO: remove these once the muscle memory is gone
vim.keymap.set("n", "go", "<nop>", {})
vim.keymap.set("n", "gO", "<nop>", {})

vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
vim.keymap.set("n", "[q", "<cmd>cnext<cr>", { desc = "Prev quickfix" })

vim.keymap.set("i", "<C-j>", "<nop>", {})
vim.keymap.set("i", "<C-k>", "<nop>", {})
vim.keymap.set("i", "<C-v>", "<nop>", {})
vim.keymap.set("i", "<C-e>", "<nop>", {})
vim.keymap.set("i", "<C-y>", "<nop>", {})

vim.keymap.set("i", "<C-c>", "<C-g>U<Esc>g~iwgi", {})
vim.keymap.set("i", "<C-s>", "<C-g>U<Esc>[s1z=gi", {})
vim.keymap.set("i", "jj", "<Esc>", {})
vim.keymap.set("i", "jk", "<Esc>", {})

vim.keymap.set("c", "<C-j>", "<Down>", {})
vim.keymap.set("c", "<C-k>", "<Up>", {})
vim.keymap.set({ "i", "c" }, "<C-h>", "<Left>", {})
vim.keymap.set({ "i", "c" }, "<C-l>", "<Right>", {})

vim.keymap.set("n", "<leader>qq", "<cmd>wa|qa<cr>", { desc = "Quick Quit" })

vim.keymap.set("n", "}", "<cmd>keepjumps normal! }<cr>")
vim.keymap.set("n", "{", "<cmd>keepjumps normal! {<cr>")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

vim.keymap.set("i", ",", ",<c-g>u", { desc = "Add undo break-point" })
vim.keymap.set("i", ".", ".<c-g>u", { desc = "Add undo break-point" })
vim.keymap.set("i", ";", ";<c-g>u", { desc = "Add undo break-point" })
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { desc = "Do nothing on spacabar" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- [[ Basic Abbreviations ]]
vim.cmd([[
cabbr h vert help
]])

-- [[ Basic Autocommands ]]

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

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("close_with_q", {}),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "close some filetypes with q",
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter", "InsertEnter", "WinLeave" }, {
  group = vim.api.nvim_create_augroup("auto_hide_cursorline", {}),
  callback = function(args)
    if args.event == "InsertEnter" or args.event == "WinLeave" then
      local cl = vim.wo.cursorline
      if cl then
        vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
        vim.wo.cursorline = false
      end
    else
      local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
      if ok and cl then
        vim.wo.cursorline = true
        vim.api.nvim_win_del_var(0, "auto-cursorline")
      end
    end
  end,
  desc = "Hide cursorline when in other window or insert mode",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", {}),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Basic Usercommands ]]
vim.api.nvim_create_user_command(
  "Gcheck",
  "cexpr system('git diff --check')",
  { desc = "Load results from 'git diff --check' into quickfix" }
)

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup({
  {
    "rebelot/kanagawa.nvim",
    priority = 10000,
    config = function()
      vim.cmd.colorscheme([[kanagawa-dragon]])
    end,
  },
  "tpope/vim-sleuth",
  -- TODO: might want do do drop this in favor of lazyvim
  "tpope/vim-fugitive",
  "tpope/vim-abolish",
  "tpope/vim-dispatch",
  "mbbill/undotree",
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      worktrees = {
        {
          toplevel = vim.env.HOME,
          gitdir = vim.env.HOME .. "/.dotfiles",
        },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        vim.keymap.set("n", "]h", gitsigns.next_hunk, { buffer = bufnr, desc = "hunk forward" })
        vim.keymap.set("n", "]h", gitsigns.prev_hunk, { buffer = bufnr, desc = "hunk backward" })
        vim.keymap.set(
          { "n", "v" },
          "<leader>gp",
          gitsigns.preview_hunk_inline,
          { buffer = bufnr, desc = "preview hunk" }
        )
        vim.keymap.set({ "n", "v" }, "<leader>gs", gitsigns.stage_hunk, { buffer = bufnr, desc = "stage hunk" })
        vim.keymap.set({ "n", "v" }, "<leader>gu", gitsigns.undo_stage_hunk, { buffer = bufnr, desc = "stage hunk" })
        vim.keymap.set({ "n", "v" }, "<leader>gr", gitsigns.reset_hunk, { buffer = bufnr, desc = "reset hunk" })
        vim.keymap.set({ "n", "v" }, "<leader>gb", gitsigns.blame_line, { buffer = bufnr, desc = "blame line" })
      end,
    },
  },
  -- TODO: learn `:help diff` better and potentially drop this
  -- Can also check-out samoshkin/vim-mergetool or whiteinge/diffconflicts or christoomey/vim-conflicted or rhysd/conflict-marker.vim for conflict resolution
  -- This is actually prob the best solution: sindrets/diffview.nvim
  { "akinsho/git-conflict.nvim", version = "*", opts = { default_mappings = false } },
  {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      require("which-key").setup()

      -- Document existing key chains
      require("which-key").register({
        ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
        ["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
        ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          path_display = { truncate = 2 },
          mappings = {
            i = {
              ["<C-j>"] = false,
              ["<C-k>"] = false,
              ["<Up>"] = require("telescope.actions").cycle_history_prev,
              ["<Down>"] = require("telescope.actions").cycle_history_next,
              ["<C-q>"] = require("telescope.actions").smart_send_to_qflist,
              ["<C-l>"] = require("telescope.actions").smart_send_to_loclist,
            },
          },
        },
        pickers = {
          buffers = {
            ignore_current_buffer = true,
            sort_mru = true,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fT", builtin.builtin, { desc = "[F]ind [T]elescope Builtins" })
      -- TODO: Add find-current-selection option
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
      vim.keymap.set("n", "<leader>fs", builtin.treesitter, { desc = "[F]ind [T]reesitter Symbols" })
      vim.keymap.set("n", "<leader>f.", builtin.resume, { desc = "[F]ind [R]esume" })
      -- TODO: should filter the results to files in the current directory
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent" })
      vim.keymap.set("n", "<leader>fc", builtin.command_history, { desc = "[F]ind [C]ommand History" })
      vim.keymap.set("n", "<leader>fS", builtin.search_history, { desc = "[F]ind [S]earch History" })
      vim.keymap.set("n", "<leader>fo", builtin.vim_options, { desc = "[F]ind Vim [O]ptions" })
      vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "[F]ind [M]arks" })
      vim.keymap.set("n", "<leader>fR", builtin.registers, { desc = "[F]ind [R]egister" })
      vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "[F]ind [J]umplist" })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
      -- TODO: might be better to save the session and switch the working directory to config dir and clear buffers
      vim.keymap.set("n", "<leader>fn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[F]ind [N]eovim files" })
      vim.keymap.set("n", "<leader>fG", builtin.git_status, { desc = "[F]ind [G]it Status Files" })

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>f/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[F]ind [/] in Open Files" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", {}),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "[C]ode [S]ymbols (Buffer)")
          map("<leader>cS", require("telescope.builtin").lsp_workspace_symbols, "[C]ode [S]ymbols (Workspace)")
          map("<Leader>ci", require("telescope.builtin").lsp_incoming_calls, "[C]ode [I]ncoming calls")
          map("<Leader>co", require("telescope.builtin").lsp_outgoing_calls, "[C]ode [O]utgoing calls")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
          map("<leader>ct", require("telescope.builtin").lsp_type_definitions, "Goto [T]ype Definition")

          map("K", vim.lsp.buf.hover, "Hover")
          vim.keymap.set(
            { "n", "i", "s" },
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
        local num_signatures = math.max(#(result.signatures or {}), 1)
        result.activeSignature = math.fmod((result.activeSignature or 0) + _G.signature_handler_offset, num_signatures)
        _G.signature_handler_offset = _G.signature_handler_offset + 1
        config = config or {}
        config.focus = false
        vim.lsp.handlers.signature_help(_, result, ctx, config)
      end

      local servers = {
        clangd = { capabilities = { offsetEncoding = { "utf-16" } } },
        gopls = {},
        pyright = {},
        rust_analyzer = { settings = { ["rust-analyzer"] = { completion = { autoimport = { enable = false } } } } },
        lua_ls = {
          -- cmd = {},
          -- filetypes = {},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
      }

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "clang-format",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            server.handlers = vim.tbl_deep_extend("force", {}, {
              ["textDocument/signatureHelp"] = signature_help,
            }, server.handlers or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- No good lsp formatting for c/cpp
        local no_lsp_fallback = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not no_lsp_fallback[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        cpp = { "clang_format" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

      vim.keymap.set("n", "<leader>cf", function()
        local bufnr = vim.api.nvim_get_current_buf()
        require("conform").format(opts.format_on_save(bufnr))
      end)
      vim.api.nvim_create_user_command("FormatToggle", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
      end, {
        desc = "Toggle autoformat-on-save globally",
      })
      vim.api.nvim_create_user_command("FormatToggleBuf", function()
        ---@diagnostic disable-next-line: inject-field
        vim.b.disable_autoformat = not vim.b.disable_autoformat
      end, {
        desc = "Toggle autoformat-on-save for a buffer",
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        -- TODO: Add snippets
        "L3MON4D3/LuaSnip",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local ls = require("luasnip")
      ---@diagnostic disable-next-line: assign-type-mismatch
      require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets" })
      vim.keymap.set("n", "<leader>se", require("luasnip.loaders").edit_snippet_files, { desc = "[S]nippet [E]dit" })
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
            item.menu = ({ nvim_lsp = " [LSP]", luasnip = "[SNIP]", buffer = " [BUF]", path = "[PATH]" })[entry.source.name]
            return item
          end,
          expandable_indicator = true,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),
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
          -- NOTE: using C-k for signature help so don't wanna clobber
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        keyword = "bg",
        pattern = [[.*<(KEYWORDS)(\(.{-}\))?:]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]],
      },
    },
    config = function(_, opts)
      require("todo-comments").setup(opts)
      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "[F]ind [T]odos" })
    end,
  },

  {
    "echasnovski/mini.nvim",
    config = function()
      local spec_treesitter = require("mini.ai").gen_spec.treesitter
      require("mini.ai").setup({
        n_lines = 500,
        custom_textobjects = {
          f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
          a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
          c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),
          o = spec_treesitter({
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          }),
        },
      })
      require("mini.align").setup()
      require("mini.surround").setup()
      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
          end,
        },
      })
      require("mini.bufremove").setup()
      vim.keymap.set("n", "<leader>bd", MiniBufremove.delete)

      -- TODO: use lualine instead
      require("mini.statusline").setup()

      require("mini.files").setup()
      vim.keymap.set("n", "<leader>E", MiniFiles.open, { desc = "File [E]xplorer" })
      vim.keymap.set("n", "<leader>e", function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      end, { desc = "File [E]xplorer (Cur-Buf)" })
    end,
  },
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "HiPhish/rainbow-delimiters.nvim",
      "nvim-treesitter/nvim-treesitter-context",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = { "bash", "c", "cpp", "html", "lua", "markdown", "vim", "vimdoc" },
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        -- Should disable here when having indenting problems.
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = false,
          node_decremental = "<M-Space>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          selection_modes = {
            ["@function.outer"] = "V",
            ["@function.inner"] = "V",
            ["@class.outer"] = "V",
            ["@class.inner"] = "V",
          },
          keymaps = {
            -- Note: the rest are set in mini.ai
            ["as"] = { query = "@scope", query_group = "locals", desc = "around scope" },
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
        -- TODO: Think about using the ;, repeat mechanisms included in the textobjects plugin
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]["] = "@class.outer",
            ["]C"] = "@class.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[c"] = "@class.outer",
            ["[z"] = { query = "@fold", query_group = "folds", desc = "Prev fold" },
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[]"] = "@class.outer",
            ["[C"] = "@class.outer",
          },
        },
        lsp_interop = {
          enable = true,
          floating_preview_opts = {
            max_height = 20,
            max_width = 50,
            border = "single",
          },
          peek_definition_code = {
            ["gp"] = "@function.outer",
            ["gP"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      require("treesitter-context").setup({ max_lines = 5, mode = "topline" })
      vim.keymap.set("n", "<leader>tc", function()
        require("treesitter-context").go_to_context()
      end, { desc = "[T]reesitter [C]ontext" })

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  {
    "danymat/neogen",
    config = function()
      local i = require("neogen.types.template").item
      local cpp_annotation_convention = {
        { nil, "/// @file", { no_results = true, type = { "file" } } },
        { nil, "/// @brief $1", { no_results = true, type = { "func", "file", "class" } } },
        { nil, "", { no_results = true, type = { "file" } } },
        { i.ClassName, "/// @class %s", { type = { "class" } } },
        { i.Type, "/// @typedef %s", { type = { "type" } } },
        { nil, "/// @brief $1", { type = { "func", "class", "type" } } },
        { i.Tparam, "/// @tparam %s $1" },
        { i.Parameter, "/// @param %s $1" },
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
    end,
    {
      "monaqa/dial.nvim",
      config = function()
        vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal())
        vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal())
        vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual())
        vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual())
      end,
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup({
        adapters = {
          require("neotest-python"),
          require("neotest-rust"),
        },
      })
      vim.keymap.set("n", "<leader>tr", require("neotest").run.run, { desc = "Run Test" })
      vim.keymap.set("n", "<leader>tf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "Test File" })
      vim.keymap.set("n", "<leader>ts", require("neotest").run.stop, { desc = "Stop Test" })
      vim.keymap.set("n", "<leader>to", require("neotest").output.open, { desc = "Test Open Output" })
      vim.keymap.set("n", "<leader>ts", require("neotest").summary.toggle, { desc = "Test Open Summary" })
    end,
  },
  { "petertriho/nvim-scrollbar", opts = {} },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {})

-- vim: ts=2 sts=2 sw=2 et
