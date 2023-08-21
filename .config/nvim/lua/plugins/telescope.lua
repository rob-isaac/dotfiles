local map = require("utils").map

local function is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end
-- TODO(Rob): have a good way to handle looking for main-repo files
-- from a subrepo by adjusting this
local function get_git_root()
  local dot_git_path = vim.fn.finddir(".git", ".;")
  return vim.fn.fnamemodify(dot_git_path, ":h")
end
local function get_picker_opts()
  return is_git_repo() and { cwd = get_git_root() } or {}
end

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "folke/noice.nvim",
      "kkharji/sqlite.lua",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "nvim-tree/nvim-web-devicons",
      "ecthelionvi/NeoComposer.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-h>"] = actions.which_key,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.smart_send_to_qflist,
              ["<C-l>"] = actions.smart_send_to_loclist,
              ["<up>"] = actions.cycle_history_prev,
              ["<down>"] = actions.cycle_history_next,
            },
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("noice")
      require("telescope").load_extension("frecency")
      require("telescope").load_extension("macros")

      local builtin = require("telescope.builtin")
      map("n", "<leader>ff", function()
        builtin.find_files(get_picker_opts())
      end, { desc = "[F]ind [F]iles (detect git repo)" })
      map("n", "<leader>fg", function()
        builtin.live_grep(get_picker_opts())
      end, { desc = "[F]ind [G]rep (detect git repo)" })
      map("n", "<leader><leader>", function()
        require("telescope").extensions.frecency.frecency({ workspace = "CWD" })
      end, { noremap = true, silent = true })
      map("n", "<leader>fF", builtin.find_files, { desc = "[F]ind [F]iles" })
      map("n", "<leader>fG", builtin.live_grep, { desc = "[F]ind [G]rep" })
      map("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [W]ord under cursor" })
      map("n", "<leader>fo", builtin.oldfiles, { desc = "[F]ind [O]ld files" })
      map("n", "<leader>fm", builtin.marks, { desc = "[F]ind [M]arks" })
      map("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      map("n", "<leader>fb", builtin.buffers, { desc = "[F]ind Open [B]uffers" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp tags" })
      map("n", "<leader>fs", builtin.treesitter, { desc = "[F]ind [S]ymbols (from treesitter)" })
      map("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
      map("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Search Buffer" })
      map("n", "<leader>fm", "<cmd>Telescope macros<cr>", { desc = "[F]ind [M]acros" })
    end,
  },
}
