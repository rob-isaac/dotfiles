local usrcmd = require("utils").usrcmd

-- Allow zooming a single window and restoring the original layout
local zoom_augroup = vim.api.nvim_create_augroup("ZoomToggle", { clear = true })
usrcmd("ZoomToggle", function()
  if vim.t.zoomed then
    vim.fn.execute(vim.t.zoomed)
    vim.t.zoomed = nil
  else
    vim.t.zoomed = vim.fn.winrestcmd()
    vim.cmd([[
      resize
      vertical resize
    ]])
    vim.api.nvim_create_autocmd({ "WinLeave" }, {
      group = zoom_augroup,
      callback = function()
        if vim.t.zoomed then
          vim.fn.execute(vim.t.zoomed)
          vim.t.zoomed = nil
        end
      end,
    })
  end
end, {})

-- Code Screenshots using Silicon
usrcmd("Screenshot", function(command)
  local out_file = command["args"]
  if not out_file then
    vim.notify("Expected an argument!")
    return
  end
  local lines = vim.api.nvim_buf_get_lines(0, command["line1"] - 1, command["line2"], true)
  vim.notify(vim.fn.system("silicon -o " .. out_file .. " -l " .. vim.fn.expand("%:e"), lines))
end, { nargs = 1, range = "%", complete = "file" })
