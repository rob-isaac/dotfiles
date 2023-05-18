local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim....")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.o.clipboard = "unnamedplus"
vim.o.number = false
vim.o.wrap = true
vim.o.pumblend = 10
vim.o.pumheight = 20
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.termguicolors = true
vim.o.splitright = true
vim.o.splitbot = true
vim.o.signcolumn = "yes"
vim.o.makeprg = "ninja"

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

local usrcmd = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end
local map = function(mode, key, mapping, opts)
  vim.keymap.set(mode, key, mapping, opts or {})
end

map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
map("t", "<esc><esc>", "<C-\\><C-n>")
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>ws", "<C-W>s", { desc = "Other window" })
map("n", "<leader>wv", "<C-W>v", { desc = "Delete window" })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>n", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>p", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- TODO(Rob): use the -modified flag to avoid issues with modified buffers
local function goModifyTags(modifier, start_row, end_row)
  local fname = vim.fn.expand("%")
  -- N.B. need to correct for zero indexing
  local cmd = "gomodifytags -format json -file "
    .. fname
    .. " -line "
    .. start_row + 1
    .. ","
    .. end_row + 1
    .. " "
    .. modifier
  local handle = io.popen(cmd)
  if not handle then
    require("notify")("Error: popen failed")
    return
  end
  local res = handle:read("*a")
  handle:close()
  local obj = vim.json.decode(res)
  if not obj then
    require("notify")("ERROR: failed to decode json")
    return
  end
  -- need to correct end_row for exclusive bound
  vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, true, obj["lines"])
end

local function getTSCursorNode()
  -- first check that we have the required parser
  local parsers = require("nvim-treesitter.parsers")
  if not parsers.has_parser() then
    require("notify")("Error: No parser")
    return
  end
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if not node then
    require("notify")("Error: could not get node at cursor")
    return
  end
  return node
end

-- Add go tags to the current struct
usrcmd("GoAddTags", function()
  local node = getTSCursorNode()

  while node do
    if node:type():find("struct") then
      -- we found the node of interest, add the tags
      local start_row, _, end_row, _ = node:range()
      goModifyTags("-add-tags json", start_row, end_row)
      return
    end
    node = node:parent()
  end
  require("notify")("Error: could not find surrounding class")
end, { nargs = 0 })

usrcmd("GoRemoveTags", function()
  local node = getTSCursorNode()

  while node do
    if node:type():find("struct") then
      -- we found the node of interest, remove the tags
      local start_row, _, end_row, _ = node:range()
      goModifyTags("-remove-tags json", start_row, end_row)
      return
    end
    node = node:parent()
  end
  require("notify")("Error: could not find surrounding class")
end, { nargs = 0 })

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
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
})

-- Show cursorline only in active window
autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})

require("lazy").setup({
  {
    "sainnhe/gruvbox-material",
    priority = 10000,
    config = function()
      vim.cmd.colorscheme([[gruvbox-material]])
    end,
  },
  { "max397574/better-escape.nvim", opts = {} },
  {
    "mrjones2014/smart-splits.nvim",
    dependencies = { { "kwkarlwang/bufresize.nvim", config = true } },
    config = function()
      local ss = require("smart-splits")
      ss.setup({
        resize_mode = {
          hooks = {
            on_leave = require("bufresize").register,
          },
        },
      })
      vim.keymap.set("n", "<A-h>", ss.resize_left)
      vim.keymap.set("n", "<A-j>", ss.resize_down)
      vim.keymap.set("n", "<A-k>", ss.resize_up)
      vim.keymap.set("n", "<A-l>", ss.resize_right)
      vim.keymap.set("n", "<C-h>", ss.move_cursor_left)
      vim.keymap.set("n", "<C-j>", ss.move_cursor_down)
      vim.keymap.set("n", "<C-k>", ss.move_cursor_up)
      vim.keymap.set("n", "<C-l>", ss.move_cursor_right)
      vim.keymap.set("n", "<leader><C-h>", ss.swap_buf_left)
      vim.keymap.set("n", "<leader><C-j>", ss.swap_buf_down)
      vim.keymap.set("n", "<leader><C-k>", ss.swap_buf_up)
      vim.keymap.set("n", "<leader><C-l>", ss.swap_buf_right)
    end,
  },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.align").setup()
      require("mini.basics").setup()
      require("mini.bracketed").setup()
      require("mini.bufremove").setup()
      map("n", "<leader>bd", MiniBufremove.delete)
      require("mini.comment").setup()
      require("mini.cursorword").setup()
      require("mini.indentscope").setup()
      require("mini.map").setup()
      require("mini.pairs").setup({
        mappings = {
          ["<"] = { action = "open", pair = "<>", neigh_pattern = "[%a%d].", register = { cr = false } },
          [">"] = { action = "close", pair = "<>", register = { cr = false } },
        },
      })
      require("mini.sessions").setup()
      require("mini.starter").setup()
      require("mini.trailspace").setup()

      vim.api.nvim_set_keymap(
        "i",
        "<S-CR>",
        "v:lua.MiniPairs.cr()",
        { noremap = true, expr = true, desc = "MiniPairs <CR>" }
      )
      vim.api.nvim_set_keymap(
        "i",
        "<S-BS>",
        "v:lua.MiniPairs.bs()",
        { noremap = true, expr = true, desc = "MiniPairs <BS>" }
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-context" },
      { "mrjones2014/nvim-ts-rainbow" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "cpp",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "go",
          "python",
          "markdown",
          "markdown_inline",
        },
        auto_install = true,
        highlight = { enable = true, additional_vim_regex_highlighting = false },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-Space>",
            node_incremental = "<C-Space>",
            scope_incremental = false,
            node_decremental = "<M-Space>",
          },
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = 2000,
        },
        context_commentstring = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
              ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
              ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = { query = "@function.outer", desc = "Next method start" },
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[s"] = { query = "@scope", query_group = "locals", desc = "Prev scope" },
              ["[z"] = { query = "@fold", query_group = "folds", desc = "Prev fold" },
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          lsp_interop = {
            enable = true,
            border = "none",
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>df"] = "@function.outer",
              ["<leader>dF"] = "@class.outer",
            },
          },
        },
      })
      require("treesitter-context").setup()
      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context()
      end, { silent = true })
    end,
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim", build = ":MasonUpdate" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "onsails/lspkind.nvim" },
      { "SmiteshP/nvim-navic" },
      -- TODO(Rob): do I need this? And should I use neoconf.nvim?
      { "folke/neodev.nvim", opts = {} },
      {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
          local null_ls = require("null-ls")
          -- TODO(Rob): Ensure installed on all these sources
          null_ls.setup({
            sources = {
              null_ls.builtins.formatting.stylua,
              null_ls.builtins.formatting.black,
              null_ls.builtins.formatting.isort,
              null_ls.builtins.formatting.latexindent,
              null_ls.builtins.formatting.clang_format,
              null_ls.builtins.formatting.gofmt,
              null_ls.builtins.formatting.fish_indent,
              null_ls.builtins.formatting.shfmt,
              null_ls.builtins.completion.spell,
              null_ls.builtins.code_actions.gomodifytags,
              null_ls.builtins.code_actions.impl,
              null_ls.builtins.code_actions.gitsigns.with({
                config = {
                  filter_actions = function(title)
                    return title:lower():match("blame") == nil -- filter out blame actions
                  end,
                },
              }),
            },
          })
        end,
      },
      { "p00f/clangd_extensions.nvim" },
    },
    config = function()
      local lsp = require("lsp-zero").preset({})

      lsp.ensure_installed({ "lua_ls", "gopls", "clangd", "rust_analyzer", "pyright" })

      local clangd_opts = require("clangd_extensions").prepare({
        server = { capabilities = { offsetEncoding = { "utf-16" } } },
        extensions = { inlay_hints = { only_current_line = true } },
      })
      -- attempt to use the environment's clang++ as the query driver
      local handle = io.popen("which clang++")
      if handle then
        local res = handle:read("*a")
        handle:close()
        res = res:gsub("[\n\r]", "")
        if res ~= "" then
          clangd_opts.cmd = { "clangd", "--query-driver", res }
        end
      end
      require("lspconfig").clangd.setup(clangd_opts)
      require("lspconfig").lua_ls.setup(vim.tbl_extend("force", lsp.nvim_lua_ls(), {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      }))

      lsp.format_on_save({
        format_opts = {
          async = false,
          timeout_ms = 5000,
        },
        servers = {
          ["null-ls"] = { "javascript", "typescript", "python", "cpp", "lua", "go" },
        },
      })

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
        map("n", "[e", function()
          vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end, { buffer = bufnr })
        map("n", "]e", function()
          vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, { buffer = bufnr })
        if client.supports_method("documentSymbols") then
          require("nvim-navic").attach(client, bufnr)
        end
      end)

      lsp.setup()

      local cmp = require("cmp")
      local cmp_action = require("lsp-zero").cmp_action()
      local context = require("cmp.config.context")

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
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            priority = 1000,
            entry_filter = function(entry)
              -- Don't show text entries from the lsp
              return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            end,
          },
          {
            name = "luasnip",
            keyword_length = 2,
            max_item_count = 5,
            priority = 750,
            entry_filter = function()
              -- don't show snippets when in comments or strings
              return not (
                context.in_treesitter_capture("comment")
                or context.in_syntax_group("Comment")
                or context.in_treesitter_capture("string")
                or context.in_syntax_group("String")
              )
            end,
          },
          { name = "buffer", keyword_length = 3, max_item_count = 5, priority = 500 },
          { name = "path", max_item_count = 5, priority = 250 },
        }),
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            item.abbr = pad_or_truncate(item.abbr, 25)
            item.kind = pad_or_truncate(require("lspkind").symbolic(item.kind, { mode = "symbol_text" }), 15)
            item.menu = ({ nvim_lsp = " [LSP]", luasnip = "[SNIP]", buffer = " [BUF]", path = "[PATH]" })[entry.source.name]
            return item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          -- Ctrl+Space to trigger completion menu
          ---@diagnostic disable-next-line: assign-type-mismatch
          ["<C-Space>"] = cmp.mapping.complete(),
          ---@diagnostic disable-next-line: assign-type-mismatch
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp_action.luasnip_supertab(),
          ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
          ["<C-f>"] = cmp_action.luasnip_jump_forward(),
          ["<C-b>"] = cmp_action.luasnip_jump_backward(),
        },
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        end,
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-file-browser.nvim",
      "folke/noice.nvim",
    },
    config = function()
      local function is_git_repo()
        vim.fn.system("git rev-parse --is-inside-work-tree")
        return vim.v.shell_error == 0
      end
      -- TODO(Rob): have a good way to handle looking for main-repo files
      -- from a subrepo by adjusting this
      local function get_git_root()
        local dot_git_path = vim.fn.finddir(".git", ".;")
        return vim.fn.fnamemodify(dot_git_path, ":h")
      end
      local function get_picker_opts()
        return is_git_repo() and { cwd = get_git_root() } or {}
      end

      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = actions.which_key,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.smart_send_to_qflist,
              ["<C-l>"] = actions.smart_send_to_loclist,
              ["<up>"] = actions.cycle_history_prev,
              ["<down>"] = actions.cycle_history_next,
            },
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("noice")
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files(get_picker_opts())
      end, {})
      vim.keymap.set("n", "<leader>fg", function()
        builtin.live_grep(get_picker_opts())
      end, {})
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [W]ord under cursor" })
      vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind [O]ld files" })
      vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "[F]ind [M]arks" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp tags" })
      vim.keymap.set("n", "<leader>fs", builtin.treesitter, { desc = "[F]ind [S]ymbols (from treesitter)" })
      vim.keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser<cr>", { desc = "[F]ile [E]xplorer" })
      vim.keymap.set("n", "<leader>e", "<cmd>Telescope file_browser<cr>", { desc = "File [E]xplorer" })
    end,
  },
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
          lsp_doc_border = true,
        },
      })
      vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end, { silent = true, expr = true })

      vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end, { silent = true, expr = true })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      { "smjonas/inc-rename.nvim", opts = {} },
    },
  },
  "goerz/jupytext.vim",
  "lervag/vimtex",
  { "dhruvasagar/vim-table-mode", ft = { "markdown", "org", "norg" } },
  {
    "skywind3000/asyncrun.vim",
    init = function()
      vim.g["asyncrun_open"] = 8
      vim.cmd([[
        command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
      ]])
    end,
  },
  {
    "tpope/vim-fugitive",
    init = function()
      vim.cmd([[
        command! -bang -bar -nargs=* Gpush execute 'AsyncRun<bang> -cwd=' .
                  \ fnameescape(FugitiveGitDir()) 'git push' <q-args>
        command! -bang -bar -nargs=* Gfetch execute 'AsyncRun<bang> -cwd=' .
                  \ fnameescape(FugitiveGitDir()) 'git fetch' <q-args>
      ]])
    end,
  },
  {
    "segeljakt/vim-silicon",
    init = function()
      vim.g.silicon = {
        theme = "gruvbox-dark",
        font = "JetBrainsMono Nerd Font",
        ["pad-vert"] = 0,
        ["pad-horiz"] = 0,
        ["line-number"] = false,
        ["round-corner"] = false,
        ["window-controls"] = false,
      }
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup()
      require("which-key").register({
        ["<leader>"] = {
          f = { name = "+[F]ind..." },
          g = { name = "+[G]it" },
        },
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        before = "",
        keyword = "bg",
        after = "",
        pattern = [[.*<(KEYWORDS).*:]], -- vim regex
      },
      search = {
        pattern = [[\b(KEYWORDS).*:]], -- ripgrep regex
      },
    },
  },
  { "folke/trouble.nvim", opts = {} },
  { "kevinhwang91/nvim-bqf", opts = {} },
  { "lukas-reineke/headlines.nvim", opts = {}, ft = { "markdown", "org", "norg" } },
  { "SmiteshP/nvim-navbuddy", opts = { lsp = { auto_attach = true } } },
  { "pwntester/octo.nvim", config = true, cmd = { "Octo" } },
  { "danymat/neogen", config = true },
  { "karb94/neoscroll.nvim", config = true },
  { "chentoast/marks.nvim", config = true },
  {
    "akinsho/toggleterm.nvim",
    keys = { [[<C-\>]] },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
    },
  },
  { "sindrets/diffview.nvim", config = true },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "SmiteshP/nvim-navic" },
    config = function()
      require("lualine").setup({
        options = {
          globalstatus = true,
        },
        sections = {
          lualine_c = {
            "navic",
            color_correction = nil,
            navic_opts = nil,
          },
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup()
      map("n", "H", "<cmd>BufferLineCyclePrev<cr>", {})
      map("n", "L", "<cmd>BufferLineCycleNext<cr>", {})
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function()
        local gs = package.loaded.gitsigns
        map("n", "]h", function()
          if vim.wo.diff then
            return "]h"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[h", function()
          if vim.wo.diff then
            return "[h"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })
      end,
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      -- don't use S b/c need it for leap.nvim
      require("nvim-surround").setup({
        keymaps = { visual = "Y", visual_line = "gY" },
      })
    end,
  },
  {
    "ggandor/flit.nvim",
    dependencies = { "ggandor/leap.nvim", "tpope/vim-repeat" },
    config = function()
      require("leap").setup({})
      require("leap").add_default_mappings()
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
      require("flit").setup({})
    end,
  },
  -- TODO: Add and configure
  -- kevinhwang91/nvim-ufo
  -- AckslD/muren.nvim or spectre
  -- mg979/vim-visual-multi
  -- chipsenkbeil/distant.nvim
  -- mrjones2014/legendary.nvim

  install = { colorscheme = { "gruvbox-material", "tokyonight", "habamax" } },
  checker = { enabled = true },
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
})
