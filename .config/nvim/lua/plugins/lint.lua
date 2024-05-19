return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        json = { "jsonlint" },
        bash = { "shellcheck" },
        sh = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = vim.api.nvim_create_augroup("lint", {}),
        callback = function()
          require("lint").try_lint()
          require("lint").try_lint("cspell")
        end,
      })
    end,
  },
}
