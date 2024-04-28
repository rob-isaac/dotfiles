-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local statusbar = require("statusbar")
local colorscheme = require("colorscheme")
local keybindings = require("keybindings")

local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Start in maximized mode
wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- Set some background opacity for the terminal
config.window_background_opacity = 0.92

-- Status configuration
wezterm.on("update-status", function(window, pane)
  statusbar.update_status(window, pane)
end)

config.force_reverse_video_cursor = true
config.colors = colorscheme.kanagawa
config.font = wezterm.font("JetBrains Mono")
config.window_padding = { left = 0, right = 0, bottom = 0, top = 0 }
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = false
config.bypass_mouse_reporting_modifiers = "CTRL|SHIFT"
config.enable_kitty_graphics = true

config.leader = { key = "a", mods = "CTRL" }

config.key_tables = keybindings.key_tables
config.keys = keybindings.keys

config.mouse_bindings = {
  -- Scrolling up while holding CTRL increases the font size
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = "CTRL",
    action = act.IncreaseFontSize,
  },

  -- Scrolling down while holding CTRL decreases the font size
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = "CTRL",
    action = act.DecreaseFontSize,
  },
  -- Select SemanticZone
  {
    event = { Down = { streak = 3, button = "Left" } },
    action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
    mods = "NONE",
  },
}

return config
