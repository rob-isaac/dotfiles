local map = require("utils").map
local format_augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local function on_attach(client, bufnr)
  local builtin = require("telescope.builtin")
  local map_buf = function(mode, key, mapping, opts)
    map(mode, key, mapping, vim.tbl_extend("force", opts, { buffer = true }))
  end

  -- Lsp behavior
  map_buf("n", "gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
  map_buf("n", "gR", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
  map_buf("n", "<leader>cs", builtin.lsp_document_symbols, { desc = "[C]ode [S]ymbols" })
  map_buf("n", "<leader>cS", builtin.lsp_workspace_symbols, { desc = "[C]ode Workspace [S]ymbols" })
  map_buf("n", "<Leader>ci", builtin.lsp_incoming_calls, { desc = "[C]ode [I]ncoming calls" })
  map_buf("n", "<Leader>co", builtin.lsp_outgoing_calls, { desc = "[C]ode [O]utgoing calls" })
  map_buf("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
  map_buf("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
  map_buf("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  map_buf({ "n", "i" }, "<M-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

  local format = function()
    vim.lsp.buf.format({
      async = false,
      buffer = bufnr,
      filter = function(c)
        return c.name == "null-ls"
      end,
    })
  end
  vim.api.nvim_clear_autocmds({ group = format_augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = format_augroup,
    buffer = bufnr,
    callback = format,
  })
  map_buf("n", "<leader>cf", format, { desc = "[C]ode [F]ormat" })
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- installer
      { "williamboman/mason.nvim", opts = {}, build = ":MasonUpdate" },

      -- formatting/linting
      { "jose-elias-alvarez/null-ls.nvim" },

      -- icons
      { "nvim-tree/nvim-web-devicons" },

      -- winbar location info
      { "SmiteshP/nvim-navic" },
      { "utilyre/barbecue.nvim", version = "*", opts = {} },

      -- dependencies for on-attach
      { "nvim-telescope/telescope.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "hrsh7th/cmp-nvim-lsp" },

      -- filetype-specific plugins
      { "folke/neodev.nvim", opts = {} },
      { "p00f/clangd_extensions.nvim" },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            workspace = {
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
      lspconfig.clangd.setup({
        capabilities = vim.tbl_extend("force", capabilities, { offsetEncoding = { "utf-16" } }),
        on_attach = on_attach,
      })
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = { python = { analysis = { typeCheckingMode = "off" } } },
      })
      lspconfig.gopls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.rust_analyzer.setup({ capabilities = capabilities, on_attach = on_attach })

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.typos,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.fish_indent,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.rustfmt.with({ extra_args = { "--edition", "2021" } }),
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.stylua,
        },
      })
    end,
  },
}
