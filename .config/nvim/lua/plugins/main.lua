return {
  { "LazyVim/LazyVim", opts = { colorscheme = "gruvbox-material" } },
  { "NvChad/nvim-colorizer.lua", config = true },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  -- there are some issues with lazy-loading + async-runner so just eagerly load for now
  { "b0o/incline.nvim", config = true },
  { "lukas-reineke/indent-blankline.nvim", lazy = false },
  { "folke/twilight.nvim", cmd = { "Twilight" }, config = true },
  { "folke/zen-mode.nvim", cmd = { "ZenMode" }, config = true },
  -- TODO(Rob): figure out why using `mode = {"n","i","t"}` didn't work
  {
    "numToStr/Navigator.nvim",
    config = true,
    keys = {
      {
        "<C-h>",
        "<CMD>NavigatorLeft<CR>",
      },
      {
        "<C-l>",
        "<CMD>NavigatorRight<CR>",
      },
      {
        "<C-k>",
        "<CMD>NavigatorUp<CR>",
      },
      {
        "<C-j>",
        "<CMD>NavigatorDown<CR>",
      },
    },
  },
  {
    "lukas-reineke/headlines.nvim",
    config = true,
    ft = {
      "markdown",
      "org",
      "norg",
    },
  },
  { "max397574/better-escape.nvim", config = true },
  { "smjonas/inc-rename.nvim", config = true },
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
  {
    "ThePrimeagen/refactoring.nvim",
    config = true,
    keys = {
      {
        "<leader>re",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
        mode = "v",
      },
      {
        "<leader>rf",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
        mode = "v",
      },
      {
        "<leader>rv",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
        mode = "v",
      },
      {
        "<leader>ri",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        mode = "v",
      },
      {
        "<leader>rb",
        [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
      },
      {
        "<leader>rbf",
        [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
      },
      {
        "<leader>ri",
        [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
      },
    },
  },
  { "chentoast/marks.nvim", config = true },
  { "abecodes/tabout.nvim", config = true, event = "InsertEnter" },
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>hm",
        function()
          require("harpoon.mark").add_file()
        end,
      },
      {
        "<leader>hh",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
      },
    },
    config = true,
  },
  {
    "akinsho/toggleterm.nvim",
    keys = { [[<C-\>]] },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
    },
  },
  { "mrjones2014/smart-splits.nvim", config = true },
  { "kwkarlwang/bufresize.nvim", config = true },
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
