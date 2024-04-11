return {
  {
    "nvim-orgmode/orgmode",
    config = function()
      require("orgmode").setup({
        org_agenda_files = vim.env.HOME .. "/orgfiles/**/*",
        org_default_notes_file = vim.env.HOME .. "/orgfiles/refile.org",
      })
    end,
  },
}
