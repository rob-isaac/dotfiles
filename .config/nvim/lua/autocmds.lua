local augroup = require("utils").augroup
local autocmd = require("utils").autocmd

-- Module object for storing data across autocommand invocations
local M = {}

autocmd({ "FocusGained", "TermClose", "TermLeave", "VimResume" }, {
  group = augroup("checktime"),
  command = "checktime",
  desc = "Check for file changes",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "restore cursor when opening buffer",
})

autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "close some filetypes with q",
})

autocmd({ "InsertLeave", "WinEnter", "InsertEnter", "WinLeave" }, {
  group = augroup("auto_hide_cursorline"),
  callback = function(args)
    if args.event == "InsertEnter" or args.event == "WinLeave" then
      local cl = vim.wo.cursorline
      if cl then
        vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
        vim.wo.cursorline = false
      end
    else
      local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
      if ok and cl then
        vim.wo.cursorline = true
        vim.api.nvim_win_del_var(0, "auto-cursorline")
      end
    end
  end,
  desc = "Hide cursorline when in other window or insert mode",
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_on_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = "Highlight after yank",
})

vim.api.nvim_create_autocmd({ "VimEnter", "RecordingEnter", "ColorScheme", "RecordingLeave" }, {
  group = augroup("cursorline_macro_indicator"),
  callback = function(args)
    if args["event"] ~= "RecordingLeave" then
      M.cursorline_orig_bg_gui = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("CursorLine")), "bg", "gui")
      M.cursorline_orig_bg_cterm = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("CursorLine")), "bg", "cterm")
    else
      vim.cmd("hi CursorLine guibg=" .. M.cursorline_orig_bg_gui .. " ctermbg=" .. M.cursorline_orig_bg_cterm)
    end
    if args["event"] == "RecordingEnter" then
      vim.cmd("hi CursorLine guibg=Red ctermbg=Red")
    end
  end,
  desc = "Indicate macro recording via cursorline color",
})
