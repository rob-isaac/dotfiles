local map = require("utils").map

return {
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
              ["aa"] = { query = "@parameter.outer", desc = "Select outer part of parameter" },
              ["aa"] = { query = "@parameter.inner", desc = "Select inner part of parameter" },
              ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
              ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
              ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "V",
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
              ["]c"] = { query = "@class.outer", desc = "Next class start" },
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[c"] = "@class.outer",
              ["[s"] = { query = "@scope", query_group = "locals", desc = "Prev scope" },
              ["[z"] = { query = "@fold", query_group = "folds", desc = "Prev fold" },
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
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
      })
      require("treesitter-context").setup()
      map("n", "[c", function()
        require("treesitter-context").go_to_context()
      end, { silent = true })
    end,
  },
}
