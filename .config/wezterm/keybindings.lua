local wezterm = require("wezterm")
local act = wezterm.action

return {
  keys = {
    {
      key = "\\",
      mods = "LEADER",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "-",
      mods = "LEADER",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "h",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "j",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "k",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "l",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Right"),
    },
    {
      key = "h",
      mods = "CTRL|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Left", 1 }),
    },
    {
      key = "j",
      mods = "CTRL|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Down", 1 }),
    },
    {
      key = "k",
      mods = "CTRL|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Up", 1 }),
    },
    {
      key = "l",
      mods = "CTRL|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Right", 1 }),
    },
    {
      key = "l",
      mods = "LEADER|CTRL",
      action = act.Multiple({
        act.ActivateTabRelative(1),
        act.ActivateKeyTable({
          name = "switch_tabs",
          timeout_milliseconds = 1000,
          one_shot = false,
          until_unknown = true,
        }),
      }),
    },
    {
      key = "h",
      mods = "LEADER|CTRL",
      action = act.Multiple({
        act.ActivateTabRelative(-1),
        act.ActivateKeyTable({
          name = "switch_tabs",
          timeout_milliseconds = 1000,
          one_shot = false,
          until_unknown = true,
        }),
      }),
    },
    {
      key = "c",
      mods = "LEADER",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "d",
      mods = "LEADER",
      action = act.CloseCurrentTab({ confirm = false }),
    },
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
      key = "a",
      mods = "LEADER|CTRL",
      action = act.SendString("\x01"),
    },
    -- Workspace Selector
    {
      key = "S",
      mods = "CTRL|SHIFT",
      action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
    },
    -- Show debug overlay
    {
      key = "D",
      mods = "CTRL",
      action = wezterm.action.ShowDebugOverlay,
    },
    { key = "UpArrow", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(-1) },
    { key = "DownArrow", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(1) },
  },
  key_tables = {
    switch_tabs = {
      { key = "l", mods = "CTRL", action = act.ActivateTabRelative(1) },
      { key = "h", mods = "CTRL", action = act.ActivateTabRelative(-1) },
    },
  },
}
