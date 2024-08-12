return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_foreground = "mix"
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },
  "tpope/vim-fugitive",
  "tpope/vim-abolish",
  "tpope/vim-dispatch",
  "tpope/vim-vinegar",
  {
    "tpope/vim-projectionist",
    init = function()
      vim.g.dispatch_compilers = { ninja = "gcc" }
    end,
  },
  { "sindrets/diffview.nvim" },

  { "williamboman/mason.nvim", opts = {} },
  { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
  {
    "ibhagwan/fzf-lua",
    config = function()
      vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
      vim.keymap.set("n", "<leader>s", "<cmd>FzfLua live_grep<cr>", { desc = "Search" })
      vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua buffers<cr>", { desc = "Search" })
      vim.keymap.set("n", "<leader>/", "<cmd>FzfLua blines<cr>", { desc = "Search" })
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.ai").setup()
      require("mini.bufremove").setup()
      require("mini.cursorword").setup()
      require("mini.completion").setup()
      require("mini.hipatterns").setup({
        highlighters = {
          xxx = { pattern = "XXX", group = "MiniHipatternsFixme" },
          fixme = { pattern = "FIXME", group = "MiniHipatternsFixme" },
          hack = { pattern = "HACK", group = "MiniHipatternsHack" },
          todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
          note = { pattern = "NOTE", group = "MiniHipatternsNote" },
        },
      })
      require("mini.operators").setup()
      require("mini.pairs").setup({
        mappings = {
          ["<"] = { action = "open", pair = "<>", neigh_pattern = "%w.", { register = { cr = false } } },
          [">"] = { action = "close", pair = "<>", neigh_pattern = "%w.", { register = { cr = false } } },
        },
      })
      require("mini.statusline").setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 40 })
            local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            local location = MiniStatusline.section_location({ trunc_width = 75 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

            local record_reg = vim.fn.reg_recording()
            if record_reg and record_reg ~= "" then
              record_reg = "recording in " .. record_reg
            end

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- End left alignment
              { hl = "MiniHipatternsFixme", strings = { record_reg } },
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            })
          end,
        },
        set_vim_settings = false,
      })
      require("mini.surround").setup()

      vim.api.nvim_create_user_command("Bd", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "delete buffer" })
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

      vim.keymap.set("n", "<leader>cf", function()
        local bufnr = vim.api.nvim_get_current_buf()
        require("conform").format(opts.format_on_save(bufnr))
      end, { desc = "Code Format" })
      vim.api.nvim_create_user_command("FormatToggle", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
      end, {
        desc = "Toggle autoformat-on-save globally",
      })
      vim.api.nvim_create_user_command("FormatToggleBuf", function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
      end, {
        desc = "Toggle autoformat-on-save for a buffer",
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
    event = { "BufReadPre", "BufNewFile" },
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
  { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },
  { "Bilal2453/luvit-meta", lazy = true },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = { library = { { path = "luvit-meta/library", words = { "vim%.uv" } } } },
  },
}
