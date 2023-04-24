return {
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local opts = {}

      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }

      -- disable when in comments or strings
      opts.enabled = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local context = require("cmp.config.context")
        -- TODO: Would be nice to enable buffer-completion-source-only for these
        return not (
          context.in_treesitter_capture("comment")
          or context.in_treesitter_capture("string")
          or context.in_syntax_group("Comment")
          or context.in_syntax_group("String")
        )
      end

      -- UI configuration
      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }
      local max_width = 50
      local source_names = {
        nvim_lsp = "(LSP)",
        path = "(Path)",
        luasnip = "(Snippet)",
        buffer = "(Buffer)",
      }
      opts.formatting = {
        format = function(entry, item)
          local icons = require("lazyvim.config").icons.kinds
          local prefix = icons[item.kind] or ""
          local postfix = source_names[entry.source.name] or ""
          item.kind = table.concat({ prefix, item.kind, postfix }, " ")
          local label = item.abbr
          if label and string.len(label) > max_width then
            local truncated = string.sub(label, 0, max_width - 3) .. "..."
            item.abbr = truncated
          end
          return item
        end,
      }
      opts.experimental = {
        ghost_text = {
          hl_group = "LspCodeLens",
        },
      }

      -- mappings
      opts.mapping = {
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-p>"] = cmp.mapping.scroll_docs(-4),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }

      -- completion sources
      opts.sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
      })
      opts.duplicates = {
        nvim_lsp = 1,
        luasnip = 1,
        buffer = 1,
        path = 1,
      }

      cmp.setup(opts)

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
    event = { "CmdlineEnter" },
    dependencies = {
      { "hrsh7th/cmp-cmdline" },
    },
  },
}
