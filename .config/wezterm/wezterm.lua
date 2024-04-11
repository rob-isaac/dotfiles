-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Helper function to capture an external command output
local function capture(cmd)
  local f = io.popen(cmd, "r")
  if not f then
    return nil
  end
  local s = f:read("*a")
  f:close()
  if not s then
    return nil
  end
  s = string.gsub(s, "^%s+", "")
  s = string.gsub(s, "%s+$", "")
  s = string.gsub(s, "[\n\r]+", " ")
  return s
end

-- Start in maximized mode
wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- Set some background opacity for the terminal
config.window_background_opacity = 0.92

-- Status configuration
local num_cpus = capture("nproc") or "1"
local time = 0
local cpu_load = ""
local cpu_usage = ""
local mem_usage = ""
wezterm.on("update-status", function(window, _)
  local table_name = window:active_key_table() or ""
  if table_name ~= "" then
    table_name = "TABLE: " .. table_name
  end

  local date = wezterm.strftime("%a %b %-d %H:%M ")

  local bat = ""
  for _, b in ipairs(wezterm.battery_info()) do
    bat = "🔋 " .. string.format("%.0f%%", b.state_of_charge * 100)
  end

  -- only update cpu usage stats every 2 seconds
  local tmp_time = math.floor(os.time() / 2)
  if tmp_time ~= time then
    time = tmp_time
    cpu_load = capture("ps -aux | awk '{print $3}' | tail -n+2 | awk '{s+=$1} END {print s}'") or "0"
    cpu_usage = "CPU: " .. math.floor(tonumber(cpu_load) / tonumber(num_cpus)) .. "%"
    mem_usage = "MEM: "
      .. (capture("free | awk -v format='%3.1f%%' '$1 ~ /Mem/ {printf(format, 100*$3/$2)}'") or "NONE")
  end

  window:set_right_status(wezterm.format({
    { Text = table_name .. "   " .. cpu_usage .. "   " .. mem_usage .. "   " .. bat .. "   " .. date },
  }))
end)

config.force_reverse_video_cursor = true
config.colors = require("colorscheme").kanagawa
config.font = wezterm.font("JetBrains Mono")
config.window_padding = { left = 0, right = 0, bottom = 0, top = 0 }
config.window_decorations = "RESIZE"

config.leader = { key = "a", mods = "CTRL" }
config.keys = {
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
  -- Toggle Zoom
  {
    key = "T",
    mods = "CTRL",
    action = wezterm.action.TogglePaneZoomState,
  },
}

config.key_tables = {
  switch_tabs = {
    { key = "l", mods = "CTRL", action = act.ActivateTabRelative(1) },
    { key = "h", mods = "CTRL", action = act.ActivateTabRelative(-1) },
  },
}

config.enable_kitty_graphics = true

return config
