return {
  map = function(mode, key, mapping, opts)
    vim.keymap.set(mode, key, mapping, opts or {})
  end,
  autocmd = vim.api.nvim_create_autocmd,
  augroup = function(name)
    return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
  end,
  usrcmd = vim.api.nvim_create_user_command,
}
