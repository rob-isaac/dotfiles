local M = {}

function M.save_session()
  local session_dir = vim.fn.stdpath("data") .. "/sessions"
  vim.fn.mkdir(session_dir, "p")
  local pwd = vim.fn.getcwd()
  if not pwd or pwd == "" then
    vim.notify("FAILED TO SAVE SESSION", vim.log.levels.ERROR)
    return
  end
  local session_name = string.gsub(pwd, "/", "%%")
  -- TODO: can incorporate the git branch as well
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_dir .. "/" .. session_name))
end

function M.load_session()
  local session_dir = vim.fn.stdpath("data") .. "/sessions"
  local pwd = vim.fn.getcwd()
  if not pwd or pwd == "" then
    vim.notify("FAILED TO LOAD SESSION", vim.log.levels.ERROR)
    return
  end
  local session_name = string.gsub(pwd, "/", "%%")
  -- TODO: can incorporate the git branch as well
  vim.cmd("source " .. vim.fn.fnameescape(session_dir .. "/" .. session_name))
end

return M
