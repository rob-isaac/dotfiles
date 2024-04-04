return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
      },
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local ls = require("luasnip")
      ---@diagnostic disable-next-line: assign-type-mismatch
      require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/snippets" })
      vim.keymap.set("n", "<leader>se", require("luasnip.loaders").edit_snippet_files, { desc = "[S]nippet [E]dit" })
      ls.config.setup({})

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
            ls.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = "menuone,preview,noselect" },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            item.abbr = pad_or_truncate(item.abbr, 25)
            item.menu = ({ nvim_lsp = " [LSP]", luasnip = "[SNIP]", buffer = " [BUF]", path = "[PATH]" })[entry.source.name]
            return item
          end,
          expandable_indicator = true,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<C-l>"] = cmp.mapping(function(fallback)
            if ls.expand_or_locally_jumpable() then
              ls.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function(fallback)
            if ls.locally_jumpable(-1) then
              ls.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-j>"] = cmp.mapping(function(fallback)
            if ls.choice_active() then
              ls.change_choice(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          -- NOTE: using C-k for signature help so don't wanna clobber
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "orgmode" },
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            -- cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.scopes,

            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      })
    end,
  },
}
