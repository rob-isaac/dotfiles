local map = require("utils").map

return {
  "goerz/jupytext.vim",
  "lervag/vimtex",
  {
    "sainnhe/gruvbox-material",
    priority = 10000,
    config = function()
      vim.cmd.colorscheme([[gruvbox-material]])
    end,
  },
  { "max397574/better-escape.nvim", opts = {} },
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.align").setup()
      require("mini.basics").setup()
      require("mini.bracketed").setup()
      require("mini.bufremove").setup()
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
      require("mini.starter").setup()
      require("mini.trailspace").setup()

      map("n", "<leader>bd", MiniBufremove.delete)
      map("i", "<S-CR>", "v:lua.MiniPairs.cr()", { noremap = true, expr = true, desc = "MiniPairs <CR>" })
      map("i", "<S-BS>", "v:lua.MiniPairs.bs()", { noremap = true, expr = true, desc = "MiniPairs <BS>" })
    end,
  },
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
  "tpope/vim-fugitive",
  "tpope/vim-abolish",
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
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
      map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Trouble Toggle" })
      map("n", "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Trouble Toggle (Workspace)" })
    end,
  },
  { "kevinhwang91/nvim-bqf", opts = {} },
  { "lukas-reineke/headlines.nvim", opts = {}, ft = { "markdown", "org", "norg" } },
  { "SmiteshP/nvim-navbuddy", opts = { lsp = { auto_attach = true } } },
  { "pwntester/octo.nvim", config = true, cmd = { "Octo" } },
  { "danymat/neogen", config = true },
  {
    "karb94/neoscroll.nvim",
    opts = { mappings = { "<C-u>", "<C-d>", "<C-y>", "<C-e>", "zt", "zz", "zb" } },
  },
  { "chentoast/marks.nvim", config = true },
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
  { "kylechui/nvim-surround", version = "*", event = "VeryLazy", opts = {} },
  {
    "folke/flash.nvim",
    config = function()
      require("flash").setup()
      map({ "n", "x", "o" }, "s", function()
        require("flash").jump()
      end, { desc = "Flash" })
      map({ "n", "o", "x" }, "S", function()
        require("flash").treesitter()
      end, { desc = "Flash Treesitter" })
      map("o", "r", function()
        require("flash").remote()
      end, { desc = "Remote Flash" })
      map({ "o", "x" }, "R", function()
        require("flash").treesitter_search()
      end, { desc = "Flash Treesitter Search" })
      map({ "c" }, "<c-s>", function()
        require("flash").toggle()
      end, { desc = "Toggle Flash Search" })
    end,
  },
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = vim.log.levels.ERROR,
        auto_session_suppress_dirs = { "~/Projects", "~/Downloads", "/" },
        auto_session_use_git_branch = false,
        auto_session_enable_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
        session_lens = {
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
      })
      map(
        "n",
        "<leader>fp",
        require("auto-session.session-lens").search_session,
        { desc = "[F]ind [P]roject (Session)" }
      )
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({ use_default_keymaps = false })
      map("n", "<leader>j", require("treesj").toggle)
    end,
  },
  -- {
  --   "monaqa/dial.nvim",
  --   config = function()
  --     map("n", "<C-f>", require("dial.map").inc_normal())
  --     map("n", "<C-b>", require("dial.map").dec_normal())
  --     map("v", "<C-f>", require("dial.map").inc_visual())
  --     map("v", "<C-b>", require("dial.map").dec_visual())
  --   end,
  -- },
  -- { "mg979/vim-visual-multi", branch = "master" },
  -- { "kevinhwang91/nvim-ufo" },
  -- { "AckslD/muren.nvim" },
  -- { "mg979/vim-visual-multi" },
  -- { "nvim-pack/nvim-spectre" },
  -- { "chipsenkbeil/distant.nvim" },
  -- { "mrjones2014/legendary.nvim" },
  -- { "Konfekt/FastFold" }
  -- { "mbbill/undotree" }
  -- { "miversen33/netman.nvim" }
  -- { "folke/edgy.nvim" }
  -- { "rafamadriz/friendly-snippets" }
  -- { "gbprod/yanky.nvim" }
  -- { "justinmk/vim-dirvish" }
  -- { "jbyuki/instant.nvim" }
  -- { "stevearc/dressing.nvim" }
  -- Look at other plugins included in lazyvim
  -- Setup DAP stuff
  -- Notes for remote dev:
  --   On remote machine: nvim --headless --listen 0.0.0.0:6666
  --   On local machine: neovide --remote-tcp=<host name>:6666
  --                     or
  --                     nvim --server <host name>:6666 --remote-ui
}
