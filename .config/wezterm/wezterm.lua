-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

local function isViProcess(pane)
	return pane:get_foreground_process_name():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
	if isViProcess(pane) then
		window:perform_action(act.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
	else
		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
	end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
	conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
	conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
	conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
	conditionalActivatePane(window, pane, "Down", "j")
end)

local function capture(cmd)
	local f = io.popen(cmd, "r")
	if not f then
		return "ERROR"
	end
	local s = f:read("*a")
	f:close()
	if not s then
		return "ERROR"
	end
	s = string.gsub(s, "^%s+", "")
	s = string.gsub(s, "%s+$", "")
	s = string.gsub(s, "[\n\r]+", " ")
	return s
end

-- Status configuration
local num_cpus = capture("nproc")
local time = 0
local cpu_load = ""
local cpu_usage = ""
local mem_usage = ""
wezterm.on("update-status", function(window, pane)
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
		cpu_load = capture("ps -aux | awk '{print $3}' | tail -n+2 | awk '{s+=$1} END {print s}'")
		cpu_usage = "CPU: " .. math.floor(tonumber(cpu_load) / tonumber(num_cpus)) .. "%"
		mem_usage = "MEM: " .. capture("free | awk -v format='%3.1f%%' '$1 ~ /Mem/ {printf(format, 100*$3/$2)}'")
	end

	window:set_right_status(wezterm.format({
		{ Text = table_name .. "   " .. cpu_usage .. "   " .. mem_usage .. "   " .. bat .. "   " .. date },
	}))
end)

-- This is where you actually apply your config choices

config.color_scheme = "Gruvbox Material (Gogh)"
config.font = wezterm.font("JetBrainsMono Nerd Font")
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
	{ key = "h", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-left") },
	{ key = "j", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-down") },
	{ key = "k", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-up") },
	{ key = "l", mods = "CTRL", action = act.EmitEvent("ActivatePaneDirection-right") },
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = act.SendString("\x01"),
	},
}

config.key_tables = {
	switch_tabs = {
		{ key = "l", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "h", mods = "CTRL", action = act.ActivateTabRelative(-1) },
	},
}

-- and finally, return the configuration to wezterm
return config
