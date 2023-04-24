local usrcmd = vim.api.nvim_create_user_command
local autocmd = vim.api.nvim_create_autocmd

-- Delete all buffers except the current one
usrcmd("BufOnly", function()
  local cbuf = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if buf ~= cbuf and not string.find(vim.api.nvim_buf_get_name(buf), "term") then
      vim.api.nvim_buf_delete(buf, {})
    end
  end
end, { nargs = 0 })

-- Delete any empty unnamed buffers
usrcmd("CleanNoNameEmptyBuffers", function()
  -- TODO(Rob): rewrite in lua
  vim.cmd([[
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val) < 0 && (getbufline(v:val, 1, "$") == [""])')
    if !empty(buffers)
        exe 'bd '.join(buffers, ' ')
    else
        echo 'No buffer deleted'
    endif
  ]])
end, { nargs = 0 })

-- Show cursorline only in active window
autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})

if not pcall(require, "config.autocmds-secret") then
  require("notify")("WARNING: couldn't find autocmds-secret")
end
