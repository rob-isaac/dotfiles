return {
  {
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- No good lsp formatting for c/cpp
        local no_lsp_fallback = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not no_lsp_fallback[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        cpp = { "clang_format" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

      vim.keymap.set("n", "<leader>cf", function()
        local bufnr = vim.api.nvim_get_current_buf()
        require("conform").format(opts.format_on_save(bufnr))
      end, { desc = "[C]ode [F]ormat" })
      vim.api.nvim_create_user_command("FormatToggle", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
      end, {
        desc = "Toggle autoformat-on-save globally",
      })
      vim.api.nvim_create_user_command("FormatToggleBuf", function()
        ---@diagnostic disable-next-line: inject-field
        vim.b.disable_autoformat = not vim.b.disable_autoformat
      end, {
        desc = "Toggle autoformat-on-save for a buffer",
      })
    end,
  },
}
