return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      -- TODO: change the fast_wrap insert binding to something with control
      require("nvim-autopairs").setup({ fast_wrap = {} })
      vim.keymap.set(
        "i",
        "<S-CR>",
        "v:lua.require'nvim-autopairs'.autopairs_cr()",
        { expr = true, replace_keycodes = false }
      )
      vim.keymap.set(
        "i",
        "<S-BS>",
        "v:lua.require'nvim-autopairs'.autopairs_bs()",
        { expr = true, replace_keycodes = false }
      )
    end,
  },
}
