local map = require("utils").map

return {
  {
    "akinsho/toggleterm.nvim",
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal

      require("toggleterm").setup({ direction = "float" })

      local shell = Terminal:new({
        on_create = function(term)
          map("t", "<esc><esc>", "<C-\\><C-n>", { buffer = term.bufnr })
          map("t", "<C-d>", function()
            term:close()
            term:send("clear")
          end, { buffer = term.bufnr })
          map({ "n", "t" }, [[<C-\>]], function()
            term:toggle()
          end, { buffer = term.bufnr })
        end,
      })

      local lazygit = Terminal:new({
        hidden = true,
        dir = "git_dir",
        on_create = function(term)
          map({ "n", "t" }, "q", function()
            term:close()
          end, { buffer = term.bufnr })
        end,
        on_close = function(term)
          -- close lazygit so it doesn't take cpu cycles
          term:send("q")
        end,
      })

      shell:spawn()
      lazygit:spawn()

      map("n", "<leader>gg", function()
        if not lazygit:is_open() then
          lazygit:send("lazygit")
          lazygit:open()
        end
      end, { desc = "Lazygit" })
      map("n", [[<C-\>]], function()
        shell:toggle()
      end, { desc = "Lazygit" })
    end,
  },
}
