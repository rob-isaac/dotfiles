local wezterm = require("wezterm")

local M = {}

M.status_state = {
  time = 0,
  cpu_usage = "",
  mem_usage = "",
}

function M.update_status(window, _)
  local leader = window:leader_is_active() and "LEADER" or ""
  local workspace_name = "WORKSPACE: " .. window:active_workspace()

  local table_name = window:active_key_table() or ""
  if table_name ~= "" then
    table_name = "TABLE: " .. table_name
  end

  local date = wezterm.strftime("%a %b %-d %H:%M ")

  local bat = ""
  for _, b in ipairs(wezterm.battery_info()) do
    bat = "🔋 " .. string.format("%.0f%%", b.state_of_charge * 100)
  end

  -- only update cpu/mem usage stats every 2 seconds
  local tmp_time = math.floor(os.time() / 2)
  if tmp_time ~= M.status_state.time then
    M.status_state.time = tmp_time

    local success, stdout, _ = wezterm.run_child_process({ "nproc" })
    local num_cpus = success and tonumber(stdout)
    if not num_cpus then
      wezterm.log_error("Couldn't calc num_cpus: " .. (success and stdout or "FAIL"))
    end

    success, stdout, _ = wezterm.run_child_process(
      wezterm.shell_split([[bash -c "ps -aux | awk '{print $3}' | tail -n+2 | awk '{s+=$1} END {print s}'"]])
    )
    local cpu_load = success and tonumber(stdout)
    if not cpu_load then
      wezterm.log_error("Couldn't calc cpu_load: " .. (success and stdout or "FAIL"))
    end

    success, stdout, _ = wezterm.run_child_process(
      wezterm.shell_split([[bash -c "free | awk -v format='%3.1f%%' '$1 ~ /Mem/ {printf(format, 100*$3/$2)}'"]])
    )
    local mem_usage = success and stdout
    if not mem_usage then
      wezterm.log_error("Couldn't calc mem_usage: " .. (success and stdout or "FAIL"))
    end

    M.status_state.cpu_usage = num_cpus and cpu_load and "CPU: " .. math.floor(cpu_load / num_cpus) .. "%" or ""
    M.status_state.mem_usage = mem_usage and "MEM: " .. mem_usage or ""
  end

  window:set_right_status(wezterm.format({
    {
      Text = leader
        .. "   "
        .. table_name
        .. "   "
        .. workspace_name
        .. "   "
        .. M.status_state.cpu_usage
        .. "   "
        .. M.status_state.mem_usage
        .. "   "
        .. bat
        .. "   "
        .. date,
    },
  }))
end

return M
