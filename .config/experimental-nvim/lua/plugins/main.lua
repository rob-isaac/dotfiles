return {
  "tpope/vim-fugitive",
  "tpope/vim-abolish",
  "tpope/vim-dispatch",
  "tpope/vim-vinegar",
  "tpope/vim-sleuth",
  "tpope/vim-eunuch",
  {
    "tpope/vim-projectionist",
    init = function()
      vim.g.dispatch_compilers = { ninja = "gcc" }
    end,
  },

  {
    "ibhagwan/fzf-lua",
    config = function()
      vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
      vim.keymap.set("n", "<leader>s", "<cmd>FzfLua live_grep<cr>", { desc = "Search" })
    end,
  },
  "nvim-treesitter/nvim-treesitter-textobjects",

  "arkav/lualine-lsp-progress",
  "nvim-lua/plenary.nvim",

  { "williamboman/mason.nvim", opts = {} },
  { "kylechui/nvim-surround", event = "InsertEnter", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
  { "Bilal2453/luvit-meta", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = { library = { { path = "luvit-meta/library", words = { "vim%.uv" } } } },
  },
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          -- diagnostics
          nls.builtins.diagnostics.commitlint,
          nls.builtins.diagnostics.fish,
          nls.builtins.diagnostics.markdownlint,
          -- formatters
          nls.builtins.formatting.asmfmt,
          nls.builtins.formatting.clang_format,
          nls.builtins.formatting.cmake_format,
          nls.builtins.formatting.fish_indent,
          nls.builtins.formatting.prettier,
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
        },
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
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
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.clangd.setup({})
      lspconfig.bashls.setup({})
      lspconfig.cmake.setup({})
      lspconfig.lua_ls.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.vimls.setup({})
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
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
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_b = {
          "b:gitsigns_head",
          {
            "diff",
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            function()
              local record_reg = vim.fn.reg_recording()
              if record_reg and record_reg ~= "" then
                return "recording in " .. record_reg
              end
              return ""
            end,
            color = { fg = "red" },
          },
          "diagnostics",
        },
        lualine_c = { "filename", "filetype" },
        lualine_x = { "lsp_progress" },
        lualine_y = { "searchcount", "selectioncount" },
        lualine_z = { "filesize", "progress", "location" },
      },
      options = { globalstatus = true },
      extensions = { "quickfix", "fugitive", "lazy", "mason" },
    },
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },
}
