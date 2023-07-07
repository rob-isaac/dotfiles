return {
  {
    "mrjones2014/smart-splits.nvim",
    dependencies = { { "kwkarlwang/bufresize.nvim", config = true } },
    config = function()
      local ss = require("smart-splits")
      ss.setup({
        resize_mode = {
          hooks = {
            on_leave = require("bufresize").register,
          },
        },
      })
      vim.keymap.set("n", "<A-h>", ss.resize_left)
      vim.keymap.set("n", "<A-j>", ss.resize_down)
      vim.keymap.set("n", "<A-k>", ss.resize_up)
      vim.keymap.set("n", "<A-l>", ss.resize_right)
      vim.keymap.set("n", "<C-h>", ss.move_cursor_left)
      vim.keymap.set("n", "<C-j>", ss.move_cursor_down)
      vim.keymap.set("n", "<C-k>", ss.move_cursor_up)
      vim.keymap.set("n", "<C-l>", ss.move_cursor_right)
      vim.keymap.set("n", "<leader><C-h>", ss.swap_buf_left)
      vim.keymap.set("n", "<leader><C-j>", ss.swap_buf_down)
      vim.keymap.set("n", "<leader><C-k>", ss.swap_buf_up)
      vim.keymap.set("n", "<leader><C-l>", ss.swap_buf_right)
    end,
  },
}
