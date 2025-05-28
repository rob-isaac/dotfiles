local wezterm = require("wezterm")
local act = wezterm.action

return {
  keys = {
    -- Vsplit
    {
      key = "\\",
      mods = "LEADER",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    -- Hsplit
    {
      key = "-",
      mods = "LEADER",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    -- Pane movements
    {
      key = "H",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "J",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "K",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "L",
      mods = "CTRL|SHIFT",
      action = act.ActivatePaneDirection("Right"),
    },
    -- Pane resize
    {
      key = "H",
      mods = "CTRL|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Left", 1 }),
    },
    {
      key = "J",
      mods = "CTRL|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Down", 1 }),
    },
    {
      key = "K",
      mods = "CTRL|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Up", 1 }),
    },
    {
      key = "L",
      mods = "CTRL|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Right", 1 }),
    },
    -- Relative tab switching
    {
      key = "n",
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
    -- Relative tab switching
    {
      key = "p",
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
    -- Relative tab switching
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
    -- Relative tab switching
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
    -- New tab
    {
      key = "c",
      mods = "LEADER",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    -- Close tab
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
      action = wezterm.action.ShowLauncherArgs({ title = "Workspace Selector", flags = "FUZZY|WORKSPACES" }),
    },
    -- Rename workspace
    {
      key = "R",
      mods = "CTRL|SHIFT",
      action = wezterm.action.PromptInputLine({
        description = "Enter new name for session",
        action = wezterm.action_callback(function(window, _, line)
          if line then
            wezterm.mux.rename_workspace(window:active_workspace(), line)
          end
        end),
      }),
    },
    -- Tab Selector
    {
      key = "E",
      mods = "CTRL|SHIFT",
      action = wezterm.action.ShowLauncherArgs({ title = "Tab Selector", flags = "FUZZY|TABS" }),
    },
    -- Show debug overlay
    {
      key = "D",
      mods = "CTRL|SHIFT",
      action = wezterm.action.ShowDebugOverlay,
    },
    -- Scroll to the previous prompt (requires shell integrations with OSC133)
    { key = "UpArrow", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(-1) },
    -- Scroll to the next prompt (requires shell integrations with OSC133)
    { key = "DownArrow", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(1) },
    -- Quickselect link and open it
    {
      key = "O",
      mods = "CTRL|SHIFT",
      action = wezterm.action.QuickSelectArgs({
        label = "open url",
        patterns = {
          "https?://\\S+",
        },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.log_info("opening: " .. url)
          wezterm.open_with(url)
        end),
      }),
    },
  },
  key_tables = {
    -- Mode for switching tabs
    switch_tabs = {
      { key = "l", mods = "CTRL", action = act.ActivateTabRelative(1) },
      { key = "h", mods = "CTRL", action = act.ActivateTabRelative(-1) },
    },
  },
}
