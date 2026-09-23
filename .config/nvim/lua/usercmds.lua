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

vim.api.nvim_create_user_command("PRDiff", function()
  local pr_base = vim
    .system({ "gh", "pr", "view", "--json", "baseRefOid", "--jq", ".baseRefOid" }, { text = true })
    :wait()
  local pr_head = vim
    .system({ "gh", "pr", "view", "--json", "headRefOid", "--jq", ".headRefOid" }, { text = true })
    :wait()
  local cur_head = vim.system({ "git", "rev-parse", "HEAD" })

  if pr_base.code ~= 0 then
    vim.notify("Failed to determine PR base branch", vim.log.levels.ERROR)
    return
  end
  if pr_head.code ~= 0 then
    vim.notify("Failed to determine PR head branch", vim.log.levels.ERROR)
    return
  end
  if pr_head.code ~= cur_head then
    vim.notify("HEAD commit does not match PR HEAD", vim.log.levels.ERROR)
    return
  end

  vim.cmd(("G diff %s"):format(vim.trim(pr_base.stdout)))
end, {})

vim.api.nvim_create_user_command("StackDiff", function()
  local view = vim.system({ "gh", "stack", "view", "--json" }, { text = true }):wait()

  if view.code ~= 0 then
    vim.notify("Failed to determine stack base", vim.log.levels.ERROR)
    return
  end

  local ok, data = pcall(vim.json.decode, view.stdout)
  if not ok or type(data) ~= "table" or not data.trunk or data.trunk == "" then
    vim.notify("Failed to determine stack base", vim.log.levels.ERROR)
    return
  end

  local base = nil
  for _, branch in ipairs(data.branches) do
    if branch.isCurrent then
      base = branch.base
      break
    end
  end
  if not base then
    vim.notify("Failed to determine stack base", vim.log.levels.ERROR)
    return
  end

  vim.cmd(("G diff %s"):format(base))
end, { desc = "Diff against gh stack trunk" })
