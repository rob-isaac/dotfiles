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

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "L3MON4D3/LuaSnip", version = "2.*", build = "make install_jsregexp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-path" },
      { "petertriho/cmp-git" },
      { "rafamadriz/friendly-snippets" },
      { "saadparwaiz1/cmp_luasnip" },
      { "p00f/clangd_extensions.nvim" },
      { "onsails/lspkind.nvim" },
    },
    config = function()
      local cmp = require("cmp")
      local context = require("cmp.config.context")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            entry_filter = function(entry)
              -- Don't show text entries from the lsp
              return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
            end,
          },
          {
            name = "luasnip",
            max_item_count = 5,
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
          { name = "buffer", keyword_length = 5, max_item_count = 5 },
          { name = "path", max_item_count = 5 },
        }),
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            item.abbr = pad_or_truncate(item.abbr, 25)
            item.kind = pad_or_truncate(require("lspkind").symbolic(item.kind, { mode = "symbol_text" }), 15)
            item.menu = ({ nvim_lsp = " [LSP]", luasnip = "[SNIP]", buffer = " [BUF]", path = "[PATH]" })[entry.source.name]
            return item
          end,
          expandable_indicator = true,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-f>"] = cmp.mapping.scroll_docs(5),
          ["<C-b>"] = cmp.mapping.scroll_docs(-5),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-k>"] = cmp.mapping(function()
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),
        },
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        end,
        experimental = {
          ghost_text = { hl_group = "LspCodeLens" },
        },
        sorting = {
          priority_weight = 10,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            require("clangd_extensions.cmp_scores"),
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
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
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" },
        }, {
          { name = "buffer" },
        }),
      })
      require("cmp_git").setup()
    end,
  },
}
