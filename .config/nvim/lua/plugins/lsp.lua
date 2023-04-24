return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        gopls = {},
        clangd = {},
      },
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
          -- attempt to use the environment's clang++ as the query driver
          local handle = io.popen("which clang++")
          if not handle then
            return
          end
          local res = handle:read("*a")
          res = res:gsub("[\n\r]", "")
          handle:close()
          if res == "" then
            return
          end
          opts.cmd = { "clangd", "--query-driver", res }
        end,
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, { nls.builtins.formatting.black, nls.builtins.formatting.isort })
      return opts
    end,
  },
  -- TODO(Rob): re-enable
  -- {
  --   "p00f/clangd_extensions.nvim",
  --   config = {
  --     extensions = {
  --       inlay_hints = {
  --         only_current_line = true,
  --       },
  --     },
  --   },
  -- },
}
