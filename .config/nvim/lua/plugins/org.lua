return {
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("orgmode").setup_ts_grammar()

      require("orgmode").setup({
        org_agenda_files = vim.env.HOME .. "/orgfiles/**/*",
        org_default_notes_file = vim.env.HOME .. "/orgfiles/refile.org",
      })
    end,
  },
}
