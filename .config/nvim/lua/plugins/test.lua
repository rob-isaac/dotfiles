return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "nvim-neotest/nvim-nio",
      "alfaix/neotest-gtest",
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup({
        adapters = {
          require("neotest-python"),
          require("neotest-rust"),
          require("neotest-gtest").setup({}),
        },
      })
      vim.keymap.set("n", "<leader>tr", require("neotest").run.run, { desc = "Run Test" })
      vim.keymap.set("n", "<leader>tf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end, { desc = "Test File" })
      vim.keymap.set("n", "<leader>ts", require("neotest").run.stop, { desc = "Stop Test" })
      vim.keymap.set("n", "<leader>to", require("neotest").output.open, { desc = "Test Open Output" })
      vim.keymap.set("n", "<leader>ts", require("neotest").summary.toggle, { desc = "Test Open Summary" })
    end,
  },
}
