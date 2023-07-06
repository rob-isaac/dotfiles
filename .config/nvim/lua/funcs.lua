local usrcmd = require("utils").usrcmd

-- TODO(Rob): use the -modified flag to avoid issues with modified buffers
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
