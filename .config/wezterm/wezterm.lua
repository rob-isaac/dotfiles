-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This table will hold the configuration.
local config = wezterm.config_builder and wezterm.config_builder() or {}

local function is_vim(pane)
	-- this is set in smart-splits.nvim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	Left = "h",
	Down = "j",
	Up = "k",
	Right = "l",
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	local mod = resize_or_move == "resize" and "META" or "CTRL"
	return {
		key = key,
		mods = mod,
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				win:perform_action({
					SendKey = { key = key, mods = mod },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

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
	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
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
}

config.key_tables = {
	switch_tabs = {
		{ key = "l", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "h", mods = "CTRL", action = act.ActivateTabRelative(-1) },
	},
}

-- and finally, return the configuration to wezterm
return config
