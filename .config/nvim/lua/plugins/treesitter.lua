local map = require("utils").map

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "mrjones2014/nvim-ts-rainbow",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      "windwp/nvim-ts-autotag",
      "andymass/vim-matchup",
      "RRethy/nvim-treesitter-endwise",
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
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
          "query",
        },
        auto_install = true,
        autotag = { enable = true },
        endwise = { enable = true },
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
        rainbow = { enable = true, extended_mode = true, max_file_lines = 2000 },
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
        playground = { enable = true },
        matchup = { enable = true },
      })
      require("treesitter-context").setup()

      ---@diagnostic disable-next-line: missing-fields
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
        languages = {
          cpp = "// %s",
        },
      })

      map("n", "<leader>tc", function()
        require("treesitter-context").go_to_context()
      end, { desc = "[T]reesitter [C]ontext" })
    end,
  },
}
