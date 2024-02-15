return {
  -- main colorscheme
  {
    "rebelot/kanagawa.nvim",
    priority = 10000,
    config = function()
      vim.cmd.colorscheme([[kanagawa-dragon]])
    end,
  },
  -- Other colorschemes
  "sainnhe/gruvbox-material",
}
