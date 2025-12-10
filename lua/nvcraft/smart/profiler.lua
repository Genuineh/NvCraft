local M = {}

--- Generates a performance report including startup time and plugin loading times.
-- @return table A table containing the performance report.
function M.get_performance_report()
  local report = {
    startup_time = "N/A",
    memory_usage = "N/A",
    plugin_times = {},
    slow_plugins = {},
  }

  -- Get memory usage (works on Linux/macOS)
  if vim.fn.has("win32") == 0 then
    local pid = vim.fn.getpid()
    local mem_command = "ps -o rss= -p " .. pid .. " 2>/dev/null"
    local mem_output = vim.fn.system(mem_command)
    if vim.v.shell_error == 0 and mem_output then
      local mem_kb = tonumber(vim.fn.trim(mem_output))
      if mem_kb then
        report.memory_usage = string.format("%.2f MB", mem_kb / 1024)
      end
    end
  end

  -- Calculate total startup time
  if vim.g.nvcraft_start_time then
    local end_time = vim.loop.hrtime()
    local elapsed_ms = (end_time - vim.g.nvcraft_start_time) / 1000000
    report.startup_time = string.format("%.2f ms", elapsed_ms)
  end

  -- Get plugin loading times from lazy.nvim, if available
  if package.loaded["lazy"] then
    local lazy_stats = require("lazy").stats()
    if lazy_stats and lazy_stats.startuptime then
      report.startup_time = string.format("%.2f ms", lazy_stats.startuptime)
    end

    local plugins = require("lazy").get_plugins()
    for _, plugin in ipairs(plugins) do
      if plugin.stats.load_time then
        local load_time_ms = plugin.stats.load_time * 1000
        table.insert(report.plugin_times, {
          name = plugin.name,
          load_time = string.format("%.2f ms", load_time_ms),
        })

        if load_time_ms > 20 then -- Threshold for a "slow" plugin
          table.insert(report.slow_plugins, {
            name = plugin.name,
            load_time = string.format("%.2f ms", load_time_ms),
          })
        end
      end
    end

    -- Sort plugins by load time (descending)
    table.sort(report.plugin_times, function(a, b)
      return tonumber(a.load_time:match("([^ ]+) ms")) > tonumber(b.load_time:match("([^ ]+) ms"))
    end)
    table.sort(report.slow_plugins, function(a, b)
      return tonumber(a.load_time:match("([^ ]+) ms")) > tonumber(b.load_time:match("([^ ]+) ms"))
    end)
  end

  return report
end


--- Displays the performance report in a popup window.
function M.show_report()
  local report = M.get_performance_report()
  local lines = { "--- NvCraft Performance Report ---", "" }

  table.insert(lines, string.format("Startup Time: %s", report.startup_time))
  table.insert(lines, string.format("Memory Usage: %s", report.memory_usage))
  table.insert(lines, "")

  if #report.slow_plugins > 0 then
    table.insert(lines, "Slow Plugins (>20ms):")
    for _, plugin in ipairs(report.slow_plugins) do
      table.insert(lines, string.format("- %s: %s", plugin.name, plugin.load_time))
    end
    table.insert(lines, "")
  end

  table.insert(lines, "All Plugin Load Times:")
  for i = 1, math.min(20, #report.plugin_times) do -- Show top 20
    local plugin = report.plugin_times[i]
    table.insert(lines, string.format("- %s: %s", plugin.name, plugin.load_time))
  end

  vim.api.nvim_echo({ { table.concat(lines, "\n"), "Normal" } }, true, {})
end

return M
