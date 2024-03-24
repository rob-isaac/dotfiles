return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", {}),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "[C]ode [S]ymbols (Buffer)")
          map("<leader>cS", require("telescope.builtin").lsp_workspace_symbols, "[C]ode [S]ymbols (Workspace)")
          map("<Leader>ci", require("telescope.builtin").lsp_incoming_calls, "[C]ode [I]ncoming calls")
          map("<Leader>co", require("telescope.builtin").lsp_outgoing_calls, "[C]ode [O]utgoing calls")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
          map("<leader>ct", require("telescope.builtin").lsp_type_definitions, "Goto [T]ype Definition")

          map("K", vim.lsp.buf.hover, "Hover")
          vim.keymap.set(
            { "n", "i", "s" },
            "<C-k>",
            vim.lsp.buf.signature_help,
            { buffer = event.buf, desc = "LSP: Signature Help" }
          )

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      _G.signature_handler_offset = 0
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertCharPre" }, {
        group = vim.api.nvim_create_augroup("reset_signature_handler_offset", {}),
        callback = function()
          _G.signature_handler_offset = 0
        end,
        desc = "reset signature handler offset on events that would close the signature help window",
      })
      local signature_help = function(_, result, ctx, config)
        result = result or {}
        local num_signatures = math.max(#(result.signatures or {}), 1)
        result.activeSignature = math.fmod((result.activeSignature or 0) + _G.signature_handler_offset, num_signatures)
        _G.signature_handler_offset = _G.signature_handler_offset + 1
        config = config or {}
        config.focus = false
        vim.lsp.handlers.signature_help(_, result, ctx, config)
      end

      local servers = {
        clangd = { capabilities = { offsetEncoding = { "utf-16" } } },
        gopls = {},
        pyright = {},
        rust_analyzer = { settings = { ["rust-analyzer"] = { completion = { autoimport = { enable = false } } } } },
        lua_ls = {
          -- cmd = {},
          -- filetypes = {},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
      }

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
        "clang-format",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            server.handlers = vim.tbl_deep_extend("force", {}, {
              ["textDocument/signatureHelp"] = signature_help,
            }, server.handlers or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
