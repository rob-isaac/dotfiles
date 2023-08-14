local map = require("utils").map

---@diagnostic disable-next-line: unused-local
local function on_attach(client, bufnr)
  local builtin = require("telescope.builtin")
  local map_buf = function(mode, key, mapping, opts)
    map(mode, key, mapping, vim.tbl_extend("force", opts, { buffer = true }))
  end

  -- Goto keymaps
  map_buf("n", "gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
  map_buf("n", "gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
  map_buf("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostic forward" })
  map_buf("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostic backward" })
  map_buf("n", "]e", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Error forward" })
  map_buf("n", "[e", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { desc = "Error backward" })

  -- Lsp behavior
  map_buf("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
  map_buf("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
  map_buf("n", "<leader>cs", builtin.lsp_document_symbols, { desc = "[C]ode [S]ymbols" })
  map_buf("n", "<leader>cS", builtin.lsp_workspace_symbols, { desc = "[C]ode Workspace [S]ymbols" })
  map_buf("n", "<Leader>ci", builtin.lsp_incoming_calls, { desc = "[C]ode [I]ncoming calls" })
  map_buf("n", "<Leader>co", builtin.lsp_outgoing_calls, { desc = "[C]ode [O]utgoing calls" })

  -- Hover
  map_buf("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
  map_buf("n", "<M-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- installer
      { "williamboman/mason.nvim", opts = {}, build = ":MasonUpdate" },

      -- formatting/linting
      { "nvimdev/guard.nvim" },

      -- icons
      { "nvim-tree/nvim-web-devicons" },
      { "j-hui/fidget.nvim", tag = "legacy", opts = {} },

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
      { "simrat39/rust-tools.nvim", opts = { server = { on_attach = on_attach } } },
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local servers = {
        lua_ls = {
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
        gopls = {},
        clangd = {
          server = { capabilities = { offsetEncoding = { "utf-16" } } },
        },
        -- Note: auto-setup by rust-tools
        -- rust_analyzer = {},
        pyright = {},
      }

      for server_name, settings in pairs(servers) do
        require("lspconfig")[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = settings,
          filetypes = settings.filetypes,
        })
      end

      local ft = require("guard.filetype")
      ft("cpp"):fmt("clang-format")
      ft("go"):fmt("gofmt")
      ft("rust"):fmt("rustfmt")
      ft("lua"):fmt("stylua")
      ft("fish"):fmt("fish_indent")
      ft("sh,bash,zsh"):fmt("shfmt")
      ft("python"):fmt("isort"):append("black")
      require("guard").setup({
        fmt_on_save = true,
        lsp_as_default_formatter = false,
      })
      map("n", "<leader>cf", "<cmd>GuardFmt<cr>", { desc = "[C]ode [F]ormat" })
    end,
  },
}
