local map = require("utils").map

return {
  -- jj and jk for escape
  { "max397574/better-escape.nvim", opts = {} },
  -- Keymap hints
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup()
      require("which-key").register({
        ["<leader>"] = {
          f = { name = "+[F]ind..." },
          g = { name = "+[G]it" },
          x = { name = "+Trouble" },
          s = { name = "+[S]end Code" },
        },
      })
    end,
  },
  -- Diagnostics list
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup()
      map("n", "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Trouble Toggle" })
      map("n", "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Trouble Toggle (Workspace)" })
      map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { desc = "Trouble quickfix" })
      map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { desc = "Trouble loclist" })
      map("n", "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>", { desc = "Trouble open references" })
      map("n", "]t", function()
        require("trouble").next({ skip_groups = true, jump = true })
      end, { desc = "next trouble diagnostic" })
      map("n", "[t", function()
        require("trouble").previous({ skip_groups = true, jump = true })
      end, { desc = "prev trouble diagnostic" })
    end,
  },
  -- Quickfixlist enhancements
  { "kevinhwang91/nvim-bqf", opts = {} },
  -- Highlight banners for headlines in notes files
  { "lukas-reineke/headlines.nvim", opts = {}, ft = { "markdown", "org", "norg" } },
  -- Breadcrumbs navigation in ranger-like explorer
  { "SmiteshP/nvim-navbuddy", opts = { lsp = { auto_attach = true } }, dependencies = "MunifTanjim/nui.nvim" },
  -- Docs generation
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
  -- Enhancements on marks
  { "chentoast/marks.nvim", config = true },
  -- View diffs easily
  { "sindrets/diffview.nvim", config = true },
  -- Git-gutter and hunk actions
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function()
        local gitsigns = require("gitsigns")
        map("n", "]h", gitsigns.next_hunk, { desc = "hunk forward" })
        map("n", "]h", gitsigns.prev_hunk, { desc = "hunk backward" })
        map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "preview hunk" })
        map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "stage hunk" })
        map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "reset hunk" })
        map("n", "<leader>gb", gitsigns.blame_line, { desc = "blame line" })
      end,
    },
  },
  -- Tagged jumping / remote-motions
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = { modes = { search = { enabled = false } } },
    -- stylua: ignore
    keys = {
      { "ss", mode = { "n", "o", "x" }, function() require("flash").jump() end, desc = "Flash" },
      { "sS", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "sr", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "sR", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  -- Better increment/decrement
  {
    "monaqa/dial.nvim",
    config = function()
      map("n", "<C-a>", require("dial.map").inc_normal())
      map("n", "<C-x>", require("dial.map").dec_normal())
      map("v", "<C-a>", require("dial.map").inc_visual())
      map("v", "<C-x>", require("dial.map").dec_visual())
    end,
  },
  -- Test runner
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup({
        adapters = {
          require("neotest-python"),
          require("neotest-rust"),
        },
      })
      map("n", "<leader>tr", require("neotest").run.run, { desc = "Run Test" })
      map("n", "<leader>tf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "Test File" })
      map("n", "<leader>ts", require("neotest").run.stop, { desc = "Stop Test" })
      map("n", "<leader>to", require("neotest").output.open, { desc = "Test Open Output" })
      map("n", "<leader>ts", require("neotest").summary.toggle, { desc = "Test Open Summary" })
    end,
  },
  -- Repl runner
  -- TODO: Switch to iron.nvim when images work in nvim terminal
  {
    "jpalardy/vim-slime",
    dependencies = {
      "goerz/jupytext.vim",
      "Klafyvel/vim-slime-cells",
    },
    init = function()
      vim.g.slime_target = "wezterm"
      vim.g.slime_default_config = { pane_direction = "Right" }
      vim.g.jupytext_fmt = "py"
      vim.g.slime_no_mappings = true
      vim.g.slime_bracketed_paste = true
      vim.g.slime_cell_delimiter = [[^\s*##]]
    end,
    config = function()
      map("n", "<leader>sz", "<Plug>SlimeConfig", { desc = "Slime Config" })
      map("n", "<leader>ss", "<Plug>SlimeCellsSendAndGoToNext", { desc = "Slime Send Cell" })
      map("n", "<leader>sn", "<Plug>SlimeCellsNext", { desc = "Slime Next Cell" })
      map("n", "<leader>sn", "<Plug>SlimeCellsPrev", { desc = "Slime Prev Cell" })
      map("n", "<leader>sl", "<Plug>SlimeLineSend", { desc = "Slime Send Line" })
      map("n", "<leader>s", "<Plug>SlimeMotionSend", { desc = "Slime Send Motion" })
      map("v", "<leader>s", "<Plug>SlimeRegionSend", { desc = "Slime Send Region" })
    end,
  },
  -- Yank to local clipboard using escape-codes
  {
    "ojroques/nvim-osc52",
    config = function()
      map("n", "<leader>y", require("osc52").copy_operator, { expr = true })
      map("n", "<leader>yy", "<leader>y_", { remap = true })
      map("v", "<leader>y", require("osc52").copy_visual)
    end,
  },
  -- Useful helper functions
  {
    "nvim-lua/plenary.nvim",
    config = function()
      P = function(v)
        print(vim.inspect(v))
        return v
      end
      RELOAD = function(...)
        require("plenary.reload").reload_module(...)
      end
      R = function(name)
        RELOAD(name)
        return require("name")
      end
      map("n", "<leader>tp", "<Plug>PlenaryTestFile", { desc = "Test with Plenary" })
    end,
  },
  -- Code symbols overview
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("aerial").setup({
        on_attach = function(bufnr)
          vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr })
          vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr })
        end,
      })
      map("n", "<leader>ta", "<cmd>AerialToggle!<cr>")
    end,
  },
  -- Todo highlighting and searching
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
  -- Scrollbar with diagnostic information
  { "petertriho/nvim-scrollbar", opts = {} },
  -- Latex integration
  "lervag/vimtex",
  -- Git command integration
  "tpope/vim-fugitive",
  -- Abbreviations, substitution patterns, and case-coercion
  "tpope/vim-abolish",
  -- Automatic detection of file indentation
  "tpope/vim-sleuth",
  -- Unix commands
  "tpope/vim-eunuch",
  -- Async processes
  "tpope/vim-dispatch",
  -- Readline keybindings in command and insert modes
  "tpope/vim-rsi",
  -- Projections and alternate files
  "tpope/vim-projectionist",
  -- Netrw enhancements
  "tpope/vim-vinegar",
  -- Automatically stop highlighting search results
  "romainl/vim-cool",
  -- Adds mode for easy creation of ascii tables
  "dhruvasagar/vim-table-mode",
  -- Lua docs in :help
  "milisims/nvim-luaref",
  -- Undo tree visualization/manuvering
  "mbbill/undotree",
  -- Async grep
  "mhinz/vim-grepper",
}
