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
    end,
    keys = {
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test File",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop Test",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open()
        end,
        desc = "Test Open Output",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Test Open Summary",
      },
    },
  },
}
