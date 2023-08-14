local map = require("utils").map

return {
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = "float",
      })
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
      map("n", "<leader>gg", function()
        lazygit:toggle()
      end, { desc = "Lazygit" })

      -- TODO(Rob): should avoid closing on exit and instead reuse the terminal
      local function xplr_term(dir)
        local prev_win = vim.api.nvim_get_current_win()
        local tmpname = os.tmpname()
        Terminal:new({
          cmd = "xplr " .. dir .. "> " .. tmpname,
          hidden = true,
          on_exit = function()
            vim.api.nvim_set_current_win(prev_win)
            for line in io.lines(tmpname) do
              vim.cmd("edit " .. line)
            end
            os.remove(tmpname)
          end,
        }):open()
      end

      map("n", "<leader>e", function()
        xplr_term(vim.fn.expand("%:p:h"))
      end, { desc = "File [E]xplorer" })

      map("n", "<leader>E", function()
        xplr_term(".")
      end, { desc = "File [E]xplorer (Root Dir)" })
    end,
  },
}
