return {
  "sainnhe/gruvbox-material",
  "goerz/jupytext.vim",
  "lervag/vimtex",
  { "itchyny/calendar.vim", cmd = { "Calendar" } },
  { "dhruvasagar/vim-table-mode", ft = { "markdown", "org", "norg" } },
  {
    "skywind3000/asyncrun.vim",
    init = function()
      vim.g["asyncrun_open"] = 8
      vim.cmd([[
        command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
      ]])
    end,
  },
  {
    "tpope/vim-fugitive",
    init = function()
      vim.cmd([[
        command! -bang -bar -nargs=* Gpush execute 'AsyncRun<bang> -cwd=' .
                  \ fnameescape(FugitiveGitDir()) 'git push' <q-args>
        command! -bang -bar -nargs=* Gfetch execute 'AsyncRun<bang> -cwd=' .
                  \ fnameescape(FugitiveGitDir()) 'git fetch' <q-args>
      ]])
    end,
  },
  {
    "segeljakt/vim-silicon",
    init = function()
      vim.g.silicon = {
        theme = "gruvbox-dark",
        font = "JetBrainsMono Nerd Font",
        ["pad-vert"] = 0,
        ["pad-horiz"] = 0,
        ["line-number"] = false,
        ["round-corner"] = false,
        ["window-controls"] = false,
      }
    end,
  },
}
