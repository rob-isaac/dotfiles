return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim" },
    opts = {
      sections = {
        lualine_b = {
          "b:gitsigns_head",
          {
            "diff",
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
          {
            function()
              local record_reg = vim.fn.reg_recording()
              if record_reg and record_reg ~= "" then
                return "recording in " .. record_reg
              end
              return ""
            end,
            color = { fg = "red" },
          },
          "diagnostics",
        },
        lualine_c = { "filename", "filetype" },
        lualine_x = {
          function()
            local linters = require("lint").get_running()
            if #linters == 0 then
              return "󰦕 LINT"
            end
            return "󱉶 " .. table.concat(linters, ", ")
          end,
          function()
            local ret = require("lsp-progress").progress()
            if ret and ret:len() > 50 then
              return ret:sub(1, 47) .. "..."
            end
            return ret
          end,
        },
        lualine_y = { "searchcount", "selectioncount" },
        lualine_z = { "filesize", "progress", "location" },
      },
      options = { globalstatus = true },
      extensions = { "quickfix", "fugitive", "lazy", "mason", "trouble" },
    },
    config = function(_, opts)
      require("lualine").setup(opts)
      require("lsp-progress").setup({})
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("lualine", {}),
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
      })
    end,
  },
}
