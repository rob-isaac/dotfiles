local map = require("utils").map

-- TODO(Rob): Seperate out lsp logic from cmp logic
return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim", build = ":MasonUpdate" },
      { "williamboman/mason-lspconfig.nvim" },
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "onsails/lspkind.nvim" },
      { "SmiteshP/nvim-navic" },
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-telescope/telescope.nvim" },
      { "folke/neodev.nvim", opts = {} },
      { "rmagatti/goto-preview", opts = {} },
      { "nvim-lua/plenary.nvim" },
      { "jay-babu/mason-null-ls.nvim" },
      { "jose-elias-alvarez/null-ls.nvim" },
      { "p00f/clangd_extensions.nvim" },
    },
    config = function()
      local lsp = require("lsp-zero").preset({})

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.fish_indent,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.latexindent,
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.completion.spell,
          null_ls.builtins.code_actions.gomodifytags,
          null_ls.builtins.code_actions.impl,
          null_ls.builtins.code_actions.gitsigns.with({
            config = {
              filter_actions = function(title)
                return title:lower():match("blame") == nil
              end,
            },
          }),
        },
      })
      require("mason-null-ls").setup({
        automatic_installation = true,
      })

      lsp.ensure_installed({ "lua_ls", "gopls", "clangd", "rust_analyzer", "pyright" })

      local clangd_opts = require("clangd_extensions").prepare({
        server = { capabilities = { offsetEncoding = { "utf-16" } } },
        extensions = { inlay_hints = { only_current_line = true } },
      })
      -- attempt to use the environment's clang++ as the query driver
      local handle = io.popen("which clang++")
      if handle then
        local res = handle:read("*a")
        handle:close()
        res = res:gsub("[\n\r]", "")
        if res ~= "" then
          clangd_opts.cmd = { "clangd", "--query-driver", res }
        end
      end
      require("lspconfig").clangd.setup(clangd_opts)
      require("lspconfig").lua_ls.setup(vim.tbl_extend("force", lsp.nvim_lua_ls(), {
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      }))

      local format_opts = {
        format_opts = {
          async = false,
          timeout_ms = 5000,
        },
        servers = {
          ["null-ls"] = { "javascript", "typescript", "python", "cpp", "lua", "go", "rust" },
        },
      }
      lsp.format_on_save(format_opts)
      lsp.format_mapping("<leader>cf", format_opts)

      lsp.on_attach(function(client, bufnr)
        local builtin = require("telescope.builtin")

        -- Goto keymaps
        map("n", "gd", builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
        map("n", "gp", require("goto-preview").goto_preview_definition, { desc = "[G]oto [P]review" })
        map("n", "gP", require("goto-preview").close_all_win, { desc = "Close Preview Windows" })
        map("n", "gt", require("goto-preview").goto_preview_type_definition, { desc = "[G]oto [T]ypedef" })
        map("n", "gr", builtin.lsp_references, { desc = "[G]oto [R]eferences" })
        map("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostic forward" })
        map("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostic backward" })
        map("n", "]e", function()
          vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, { desc = "Error forward" })
        map("n", "[e", function()
          vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end, { desc = "Error backward" })

        -- Lsp behavior
        map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
        map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
        map("n", "<leader>cs", builtin.lsp_document_symbols, { desc = "[C]ode [S]ymbols" })
        map("n", "<leader>cS", builtin.lsp_workspace_symbols, { desc = "[C]ode Workspace [S]ymbols" })
        map("n", "<Leader>ci", builtin.lsp_incoming_calls, { desc = "[C]ode [I]ncoming calls" })
        map("n", "<Leader>co", builtin.lsp_outgoing_calls, { desc = "[C]ode [O]utgoing calls" })

        -- Hover
        map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

        if client.supports_method("documentSymbols") then
          require("nvim-navic").attach(client, bufnr)
        end
      end)

      lsp.setup()

      local cmp = require("cmp")
      local cmp_action = require("lsp-zero").cmp_action()
      local context = require("cmp.config.context")

      local function pad_or_truncate(s, l)
        if not s then
          return string.rep(" ", l)
        end
        if s:len() < l then
          return s .. string.rep(" ", l - s:len())
        else
          return string.sub(s, 1, l - 3) .. "..."
        end
      end
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            priority = 1000,
            entry_filter = function(entry)
              -- Don't show text entries from the lsp
              return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            end,
          },
          {
            name = "luasnip",
            keyword_length = 2,
            max_item_count = 5,
            priority = 750,
            entry_filter = function()
              -- don't show snippets when in comments or strings
              return not (
                context.in_treesitter_capture("comment")
                or context.in_syntax_group("Comment")
                or context.in_treesitter_capture("string")
                or context.in_syntax_group("String")
              )
            end,
          },
          { name = "buffer", keyword_length = 3, max_item_count = 5, priority = 500 },
          { name = "path", max_item_count = 5, priority = 250 },
        }),
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            item.abbr = pad_or_truncate(item.abbr, 25)
            item.kind = pad_or_truncate(require("lspkind").symbolic(item.kind, { mode = "symbol_text" }), 15)
            item.menu = ({ nvim_lsp = " [LSP]", luasnip = "[SNIP]", buffer = " [BUF]", path = "[PATH]" })[entry.source.name]
            return item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          -- Ctrl+Space to trigger completion menu
          ---@diagnostic disable-next-line: assign-type-mismatch
          ["<C-Space>"] = cmp.mapping.complete(),
          ---@diagnostic disable-next-line: assign-type-mismatch
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp_action.luasnip_supertab(),
          ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),
          ["<C-f>"] = cmp.mapping.scroll_docs(5),
          ["<C-b>"] = cmp.mapping.scroll_docs(-5),
          ["<C-j>"] = cmp_action.luasnip_jump_forward(),
          ["<C-k>"] = cmp_action.luasnip_jump_backward(),
        },
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        end,
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
