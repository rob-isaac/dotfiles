return {
  "numToStr/FTerm.nvim",
  config = function()
    local fterm = require("FTerm")

    -- TODO: clear mappings for the lazygit buffer
    local lazygit = fterm:new({
      ft = "fterm_lazygit",
      cmd = "lazygit",
      dimensions = { height = 0.9, width = 0.9 },
    })

    vim.keymap.set("n", "<leader>gg", function()
      lazygit:toggle()
    end, { desc = "Toggle lazygit" })
    vim.keymap.set({ "n", "t" }, [[<C-\>]], fterm.toggle, { desc = "Toggle lazygit" })
  end,
}
