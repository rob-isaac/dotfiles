local M = {}

local function scheme_for(mode)
  return mode == "light" and "dayfox" or "nightfox"
end

local function apply(mode)
  local name = scheme_for(mode)
  if vim.g.colors_name == name then
    return
  end
  vim.cmd.colorscheme(name)
end

local function parse_hex_component(hex)
  local n = tonumber(hex, 16)
  if not n then
    return nil
  end
  local max = (16 ^ #hex) - 1
  return n / max
end

-- Ghostty/tmux send DSR 997 (1=dark, 2=light). Neovim also re-queries OSC 11.
-- Nightfox sets vim.o.background when a colorscheme loads, which would pin
-- Neovim's built-in detector, so we parse the terminal sequences ourselves.
local function mode_from_sequence(seq)
  if type(seq) ~= "string" then
    return nil
  end
  if seq:find("\27[?997;1n", 1, true) then
    return "dark"
  end
  if seq:find("\27[?997;2n", 1, true) then
    return "light"
  end
  local r, g, b = seq:match("%]11;rgba?:([%x]+)/([%x]+)/([%x]+)")
  if not r then
    return nil
  end
  local rr, gg, bb = parse_hex_component(r), parse_hex_component(g), parse_hex_component(b)
  if not (rr and gg and bb) then
    return nil
  end
  local luminance = 0.299 * rr + 0.587 * gg + 0.114 * bb
  return luminance < 0.5 and "dark" or "light"
end

function M.setup()
  -- :help 'background': changing it while g:colors_name is set reloads the
  -- colorscheme. Nightfox sets background during load, which re-enters
  -- :colorscheme. Nightfox's load lock drops the nested call, so ColorScheme
  -- autocmds (lualine, etc.) run against a half-applied theme. That is why a
  -- fresh dayfox start looks fine (background is already light, so no reload)
  -- but :colorscheme dayfox after nightfox does not.
  vim.api.nvim_create_autocmd("ColorSchemePre", {
    group = vim.api.nvim_create_augroup("user-terminal-theme-prescheme", { clear = true }),
    pattern = "*fox",
    callback = function(ev)
      vim.g.colors_name = nil
      local light = ev.match == "dayfox" or ev.match == "dawnfox"
      vim.o.background = light and "light" or "dark"
      vim.cmd.highlight("clear")
      if vim.fn.exists("syntax_on") == 1 then
        vim.cmd.syntax("reset")
      end
    end,
  })

  apply(vim.o.background == "light" and "light" or "dark")

  vim.api.nvim_create_autocmd("TermResponse", {
    group = vim.api.nvim_create_augroup("user-terminal-theme", { clear = true }),
    callback = function(ev)
      local seq = ev.data
      if type(seq) == "table" then
        seq = seq.sequence
      end
      local mode = mode_from_sequence(seq)
      if not mode then
        return
      end
      vim.schedule(function()
        apply(mode)
      end)
    end,
  })
end

return M
