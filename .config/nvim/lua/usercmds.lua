vim.api.nvim_create_user_command("ConfigEdit", "e $MYVIMRC", { desc = "Edit Config" })

vim.api.nvim_create_user_command("SwapWords", function(opts)
  if #opts.fargs ~= 2 then
    print("Usage SwapWords <word1> <word2>")
    return
  end
  local word1 = vim.fn.escape(opts.fargs[1], [[\/]])
  local word2 = vim.fn.escape(opts.fargs[2], [[\/]])
  vim.cmd(
    string.format(
      [[:%d,%ds/\<%s\>\|\<%s\>/\={'%s':'%s','%s':'%s'}[submatch(0)]/g]],
      opts.line1,
      opts.line2,
      word1,
      word2,
      word1,
      word2,
      word2,
      word1
    )
  )
end, { nargs = "*", range = true, desc = "Swap Two Words" })
