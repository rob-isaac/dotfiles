return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-tree/nvim-web-devicons",
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          path_display = { truncate = 2 },
          mappings = {
            i = {
              ["<C-j>"] = false,
              ["<C-k>"] = false,
              ["<Up>"] = require("telescope.actions").cycle_history_prev,
              ["<Down>"] = require("telescope.actions").cycle_history_next,
              ["<C-q>"] = require("telescope.actions").smart_send_to_qflist,
              ["<C-l>"] = require("telescope.actions").smart_send_to_loclist,
            },
          },
        },
        pickers = {
          buffers = {
            ignore_current_buffer = true,
            sort_mru = true,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
          undo = {},
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
      pcall(require("telescope").load_extension, "undo")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fT", builtin.builtin, { desc = "[F]ind [T]elescope Builtins" })
      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
      vim.keymap.set("n", "<leader>fs", builtin.treesitter, { desc = "[F]ind [T]reesitter Symbols" })
      vim.keymap.set("n", "<leader>f.", builtin.resume, { desc = "[F]ind [R]esume" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent" })
      vim.keymap.set("n", "<leader>fc", builtin.command_history, { desc = "[F]ind [C]ommand History" })
      vim.keymap.set("n", "<leader>fS", builtin.search_history, { desc = "[F]ind [S]earch History" })
      vim.keymap.set("n", "<leader>fo", builtin.vim_options, { desc = "[F]ind Vim [O]ptions" })
      vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "[F]ind [M]arks" })
      vim.keymap.set("n", "<leader>fR", builtin.registers, { desc = "[F]ind [R]egister" })
      vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "[F]ind [J]umplist" })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>fn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[F]ind [N]eovim files" })
      vim.keymap.set("n", "<leader>fG", builtin.git_status, { desc = "[F]ind [G]it Status Files" })
      vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>", { desc = "[F]ind [U]ndo" })

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>f/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[F]ind [/] in Open Files" })
    end,
  },
}
