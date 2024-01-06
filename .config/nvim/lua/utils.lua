M = {}

M.map = function(mode, key, mapping, opts)
  vim.keymap.set(mode, key, mapping, vim.tbl_extend("force", { silent = true }, opts or {}))
end

M.autocmd = vim.api.nvim_create_autocmd

M.augroup = function(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

M.usrcmd = vim.api.nvim_create_user_command

return M
