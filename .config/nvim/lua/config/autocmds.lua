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

local function goModifyTags(modifier, start_row, end_row)
  local fname = vim.fn.expand("%")
  -- N.B. need to correct for zero indexing
  local cmd = "gomodifytags -format json -file "
    .. fname
    .. " -line "
    .. start_row + 1
    .. ","
    .. end_row + 1
    .. " "
    .. modifier
  local handle = io.popen(cmd)
  if not handle then
    require("notify")("Error: popen failed")
    return
  end
  local res = handle:read("*a")
  handle:close()
  local obj = vim.json.decode(res)
  if not obj then
    require("notify")("ERROR: failed to decode json")
    return
  end
  -- need to correct end_row for exclusive bound
  vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, true, obj["lines"])
end

local function getTSCursorNode()
  -- first check that we have the required parser
  local parsers = require("nvim-treesitter.parsers")
  if not parsers.has_parser() then
    require("notify")("Error: No parser")
    return
  end
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if not node then
    require("notify")("Error: could not get node at cursor")
    return
  end
  return node
end

-- Add go tags to the current struct
usrcmd("GoAddTags", function()
  local node = getTSCursorNode()

  while node do
    if node:type():find("struct") then
      -- we found the node of interest, add the tags
      local start_row, _, end_row, _ = node:range()
      goModifyTags("-add-tags json", start_row, end_row)
      return
    end
    node = node:parent()
  end
  require("notify")("Error: could not find surrounding class")
end, { nargs = 0 })

usrcmd("GoRemoveTags", function()
  local node = getTSCursorNode()

  while node do
    if node:type():find("struct") then
      -- we found the node of interest, remove the tags
      local start_row, _, end_row, _ = node:range()
      goModifyTags("-remove-tags json", start_row, end_row)
      return
    end
    node = node:parent()
  end
  require("notify")("Error: could not find surrounding class")
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
