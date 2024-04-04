return {
  "tpope/vim-sleuth",
  "tpope/vim-abolish",
  "tpope/vim-dispatch",
  {
    "rebelot/kanagawa.nvim",
    priority = 10000,
    config = function()
      vim.cmd.colorscheme([[kanagawa-dragon]])
    end,
  },
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
        ["<leader>t"] = { name = "[T]est", _ = "which_key_ignore" },
        ["<leader>o"] = { name = "[O]rg", _ = "which_key_ignore" },
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

      require("mini.cursorword").setup()
      require("mini.splitjoin").setup()

      require("mini.files").setup()
      vim.keymap.set("n", "<leader>E", MiniFiles.open, { desc = "File [E]xplorer" })
      vim.keymap.set("n", "<leader>e", function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      end, { desc = "File [E]xplorer (Cur-Buf)" })

      require("mini.move").setup({
        mappings = {
          left = "<S-left>",
          right = "<S-right>",
          down = "<S-down>",
          up = "<S-up>",

          line_left = "<S-left>",
          line_right = "<S-right>",
          line_down = "<S-down>",
          line_up = "<S-up>",
        },
      })
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
  },
  {
    "monaqa/dial.nvim",
    config = function()
      vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal())
      vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal())
      vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual())
      vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual())
    end,
  },
  { "petertriho/nvim-scrollbar", opts = {} },
  {
    "cshuaimin/ssr.nvim",
    config = function()
      require("ssr").setup()
      vim.keymap.set({ "n", "x" }, "<leader>sr", function()
        require("ssr").open()
      end, { desc = "Structural Search Replace" })
    end,
  },
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      on_attach = function(bufnr)
        vim.keymap.set("n", "]a", "<cmd>AerialNext<CR>", { buffer = bufnr })
        vim.keymap.set("n", "[a", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      end,
    },
    config = function(_, opts)
      require("aerial").setup(opts)
      vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<cr>", { desc = "[A]erial Toggle" })
    end,
  },
  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { globalstatus = true }, extensions = { "quickfix", "fugitive", "lazy", "mason" } },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup()

      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():append()
      end)
      vim.keymap.set("n", "<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      vim.keymap.set("n", "<leader>h1", function()
        harpoon:list():select(1)
      end)
      vim.keymap.set("n", "<leader>h2", function()
        harpoon:list():select(2)
      end)
      vim.keymap.set("n", "<leader>h3", function()
        harpoon:list():select(3)
      end)
      vim.keymap.set("n", "<leader>h4", function()
        harpoon:list():select(4)
      end)

      vim.keymap.set("n", "<leader>hp", function()
        harpoon:list():prev()
      end)
      vim.keymap.set("n", "<leader>hn", function()
        harpoon:list():next()
      end)
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", function()
        require("trouble").toggle()
      end)
      vim.keymap.set("n", "<leader>xw", function()
        require("trouble").toggle("workspace_diagnostics")
      end)
      vim.keymap.set("n", "<leader>xd", function()
        require("trouble").toggle("document_diagnostics")
      end)
      vim.keymap.set("n", "<leader>xq", function()
        require("trouble").toggle("quickfix")
      end)
      vim.keymap.set("n", "<leader>xl", function()
        require("trouble").toggle("loclist")
      end)
    end,
  },
  { "kevinhwang91/nvim-bqf", opts = {} },
}
