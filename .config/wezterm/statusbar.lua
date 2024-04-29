local wezterm = require("wezterm")

local M = {}

M.status_state = {
  time = 0,
  cpu_usage = "",
  mem_usage = "",
}

function M.update_status(window, _)
  local leader = window:leader_is_active() and "LEADER" or nil

  local table_name = window:active_key_table()
  if table_name then
    table_name = wezterm.nerdfonts.md_table_furniture .. " " .. table_name
  end

  local workspace_name = wezterm.nerdfonts.cod_beaker .. " " .. window:active_workspace()

  local date = wezterm.nerdfonts.fa_clock_o .. " " .. wezterm.strftime("%Y-%m-%d %H:%M")

  local bat = ""
  for _, b in ipairs(wezterm.battery_info()) do
    bat = wezterm.nerdfonts.md_battery_high .. " " .. string.format("%.0f%%", b.state_of_charge * 100)
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

    M.status_state.cpu_usage = num_cpus
        and cpu_load
        and wezterm.nerdfonts.cod_symbol_event .. " " .. math.floor(cpu_load / num_cpus) .. "%"
      or ""
    M.status_state.mem_usage = mem_usage and wezterm.nerdfonts.cod_symbol_field .. " " .. mem_usage or ""
  end

  local sep = " " .. wezterm.nerdfonts.pl_right_soft_divider .. " "
  window:set_right_status(wezterm.format({
    {
      Text = sep
        .. (leader and leader .. sep or "")
        .. (table_name and table_name .. sep or "")
        .. workspace_name
        .. sep
        .. M.status_state.cpu_usage
        .. sep
        .. M.status_state.mem_usage
        .. sep
        .. bat
        .. sep
        .. date
        .. sep,
    },
  }))
end

return M
