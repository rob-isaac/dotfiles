local M = {}

M.cfilter_state = {
  need_to_restore = false,
  restore_items = {},
}

function M.is_quickfix_open()
  for i = 1, vim.fn.winnr("$") do
    if vim.fn.getwinvar(i, "&syntax") == "qf" then
      return true
    end
  end
  return false
end

local function positive_filter(matcher, input_items)
  local output_lines = {}
  for _, line in ipairs(input_items) do
    if line.bufnr ~= 0 then
      local bufname = vim.api.nvim_buf_get_name(line.bufnr)
      if bufname and matcher:match_str(bufname) then
        table.insert(output_lines, line)
      end
    end
  end
  return output_lines
end

local function negative_filter(matcher, input_items)
  local output_lines = {}
  for _, line in ipairs(input_items) do
    if line.bufnr ~= 0 then
      local bufname = vim.api.nvim_buf_get_name(line.bufnr)
      if bufname and not matcher:match_str(bufname) then
        table.insert(output_lines, line)
      end
    end
  end
  return output_lines
end

local function cfilter_file_preview(opts)
  if not M.is_quickfix_open() then
    return 1
  end
  if M.cfilter_state.need_to_restore == false then
    M.cfilter_state.need_to_restore = true
    M.cfilter_state.restore_items = vim.fn.getqflist()
  end
  local matcher = vim.regex(opts.args)
  local output_lines = opts.bang and negative_filter(matcher, M.cfilter_state.restore_items)
    or positive_filter(matcher, M.cfilter_state.restore_items)
  vim.fn.setqflist(output_lines, "r")
  return 1
end

local function cfilter_file(opts)
  local input_lines = vim.fn.getqflist()
  if M.cfilter_state.need_to_restore == true then
    M.cfilter_state.need_to_restore = false
    input_lines = M.cfilter_state.restore_items
    M.cfilter_state.restore_items = {}
  end
  local matcher = vim.regex(opts.args)
  local output_lines = opts.bang and negative_filter(matcher, input_lines) or positive_filter(matcher, input_lines)
  vim.fn.setqflist(output_lines)
end

vim.api.nvim_create_user_command(
  "Cfilter",
  cfilter_file,
  { nargs = 1, preview = cfilter_file_preview, bang = true, desc = "Filter quickfix list" }
)
vim.keymap.set("n", "<leader>qf", ":Cfilter ", { desc = "[Q]uickfix [F]ilter" })
vim.keymap.set("n", "<leader>qF", ":Cfilter! ", { desc = "[Q]uickfix [F]ilter" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(event)
    vim.keymap.set("n", "<C-n>", function()
      local list = vim.fn.getqflist()
      local cpos = vim.api.nvim_win_get_cursor(0)
      for i = cpos[1] + 1, #list do
        local line = list[i]
        if line.valid == 1 then
          cpos[1] = i
          cpos[2] = 0
          vim.api.nvim_win_set_cursor(0, cpos)
          return
        end
      end
    end, { buffer = event.buf, desc = "Jump Forward to Valid" })

    vim.keymap.set("n", "<C-p>", function()
      local list = vim.fn.getqflist()
      local cpos = vim.api.nvim_win_get_cursor(0)
      for i = cpos[1] - 1, 1, -1 do
        local line = list[i]
        if line.valid == 1 then
          cpos[1] = i
          cpos[2] = 0
          vim.api.nvim_win_set_cursor(0, cpos)
          return
        end
      end
    end, { buffer = event.buf, desc = "Jump Backward to Valid" })

    vim.keymap.set("n", "u", "<cmd>colder<cr>", { desc = "Restore previous quickfix", buffer = event.buf })
    vim.keymap.set("n", "<C-r>", "<cmd>cnewer<cr>", { desc = "Restore next quickfix", buffer = event.buf })
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function()
    if M.cfilter_state.need_to_restore then
      vim.fn.setqflist(M.cfilter_state.restore_items, "r")
      M.cfilter_state.need_to_restore = false
      M.cfilter_state.restore_items = {}
    end
  end,
})

return M
