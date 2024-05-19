return {
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      worktrees = {
        {
          toplevel = vim.env.HOME,
          gitdir = vim.env.HOME .. "/.dotfiles",
        },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")
        vim.keymap.set("n", "]h", gitsigns.next_hunk, { buffer = bufnr, desc = "hunk forward" })
        vim.keymap.set("n", "[h", gitsigns.prev_hunk, { buffer = bufnr, desc = "hunk backward" })
        vim.keymap.set({ "n", "v" }, "<leader>gp", gitsigns.preview_hunk, { buffer = bufnr, desc = "preview hunk" })
        vim.keymap.set(
          { "n", "v" },
          "<leader>gi",
          gitsigns.preview_hunk_inline,
          { buffer = bufnr, desc = "preview hunk inline" }
        )
        vim.keymap.set({ "n", "v" }, "<leader>gs", gitsigns.stage_hunk, { buffer = bufnr, desc = "stage hunk" })
        vim.keymap.set({ "n", "v" }, "<leader>gu", gitsigns.undo_stage_hunk, { buffer = bufnr, desc = "stage hunk" })
        vim.keymap.set({ "n", "v" }, "<leader>gr", gitsigns.reset_hunk, { buffer = bufnr, desc = "reset hunk" })
        vim.keymap.set({ "n", "v" }, "<leader>gb", gitsigns.blame_line, { buffer = bufnr, desc = "blame line" })
      end,
    },
  },
}
