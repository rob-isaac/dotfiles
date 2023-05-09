return {
  { "LazyVim/LazyVim", opts = { colorscheme = "gruvbox-material" } },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.util.project" },

  { "lukas-reineke/headlines.nvim", config = true, ft = { "markdown", "org", "norg" } },
  { "max397574/better-escape.nvim", config = true },
  { "smjonas/inc-rename.nvim", config = true },
  { "folke/noice.nvim", opts = { presets = { inc_rename = true, lsp_doc_border = true } } },
  {
    "SmiteshP/nvim-navbuddy",
    opts = { lsp = { auto_attach = true } },
    cmd = {
      "Navbuddy",
    },
  },
  { "pwntester/octo.nvim", config = true, cmd = { "Octo" } },
  { "danymat/neogen", config = true },
  { "karb94/neoscroll.nvim", config = true },
  { "kevinhwang91/nvim-bqf", ft = "qf", config = true },
  { "chentoast/marks.nvim", config = true },
  {
    "akinsho/toggleterm.nvim",
    keys = { [[<C-\>]] },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    dependencies = { { "kwkarlwang/bufresize.nvim", config = true } },
    event = "BufReadPre",
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
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "cpp" },
    },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-context", config = true },
      {
        "mrjones2014/nvim-ts-rainbow",
        config = function()
          require("nvim-treesitter.configs").setup({
            rainbow = {
              enable = true,
              extended_mode = true,
              max_file_lines = 2000,
            },
          })
        end,
      },
    },
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
  -- TODO(Rob): lazy load on commands
  {
    "sindrets/diffview.nvim",
    config = true,
  },
  {
    "echasnovski/mini.pairs",
    config = function()
      -- Note: would be nice to conditionally add these mappings on filetype but there is
      -- an issue with running vim with args and running the mapping via FileType autocmd
      require("mini.pairs").setup({
        mappings = {
          ["<"] = { action = "open", pair = "<>", neigh_pattern = "[%a%d].", register = { cr = false } },
          [">"] = { action = "close", pair = "<>", register = { cr = false } },
        },
      })
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

  -- TODO: Add and configure
  -- {"kevinhwang91/nvim-ufo"}
  -- TODO(Rob): https://github.com/chipsenkbeil/distant.nvim
  -- TODO(Rob): https://github.com/mrjones2014/legendary.nvim
}
