local map = require("utils").map

return {
  -- grab-bag of enhancements
  {
    "echasnovski/mini.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      local spec_treesitter = require("mini.ai").gen_spec.treesitter
      -- textobjects
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
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      })

      -- interactive alignment
      require("mini.align").setup()

      -- basic options, keymaps, and autocommands
      require("mini.basics").setup({
        options = {
          extra_ui = true,
          win_borders = "double",
          move_with_alt = true,
        },
      })

      -- commands for removing/hiding buffers
      require("mini.bufremove").setup()
      map("n", "<leader>bd", MiniBufremove.delete)

      -- commands for commenting/uncommenting
      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
          end,
        },
      })

      -- highlight occurrences of word under the cursor
      require("mini.cursorword").setup()

      -- highlight patterns
      require("mini.hipatterns").setup({
        highlighters = {
          hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
        },
      })

      -- mark the indent-scope of the cursor
      require("mini.indentscope").setup()

      -- command for making a floating map + scrollbar of the current file
      require("mini.map").setup()
      map("n", "<leader>m", MiniMap.toggle, { desc = "[M]inimap Toggle" })

      -- interactively move text blocks
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

      -- evaluate, exchange, multiply, replace, sort operators
      require("mini.operators").setup()

      -- autopairs
      require("mini.pairs").setup({
        mappings = {
          ["<"] = { action = "open", pair = "<>", neigh_pattern = "[%a%d].", register = { cr = false } },
          [">"] = { action = "close", pair = "<>", register = { cr = false } },
        },
      })
      map("i", "<S-CR>", "v:lua.MiniPairs.cr()", { expr = true, replace_keycodes = false, desc = "MiniPairs <CR>" })
      map("i", "<S-BS>", "v:lua.MiniPairs.bs()", { expr = true, replace_keycodes = false, desc = "MiniPairs <BS>" })

      -- add, change, remove surroundings
      require("mini.surround").setup()

      -- split and join args across lines
      require("mini.splitjoin").setup()

      -- file explorer
      require("mini.files").setup()
      map("n", "<leader>E", MiniFiles.open, { desc = "File [E]xplorer" })
      map("n", "<leader>e", function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      end, { desc = "File [E]xplorer (Cur-Buf)" })
    end,
  },
}
