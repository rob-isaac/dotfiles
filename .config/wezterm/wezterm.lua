-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local statusbar = require("statusbar")
local keybindings = require("keybindings")

local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Set default shell to fish
config.default_prog = { "/usr/bin/fish", "-l" }

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
config.font = wezterm.font("JetBrains Mono")
config.color_scheme = "nightfox"
config.window_padding = { left = 0, right = 0, bottom = 0, top = 0 }
config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
config.use_fancy_tab_bar = false
config.bypass_mouse_reporting_modifiers = "CTRL|SHIFT"
config.enable_kitty_graphics = true
config.tab_max_width = 30

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

-- Allow clicking hyperlinks of the form user/project
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = "https://www.github.com/$1/$3",
})

return config
