return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "HiPhish/rainbow-delimiters.nvim",
      "nvim-treesitter/nvim-treesitter-context",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    opts = {
      ensure_installed = { "bash", "c", "cpp", "html", "lua", "markdown", "vim", "vimdoc", "org" },
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
            -- NOTE: the rest are set in mini.ai
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
    end,
  },
}
