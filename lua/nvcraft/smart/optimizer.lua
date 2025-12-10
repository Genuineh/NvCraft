local M = {}

local profiler = require("nvcraft.smart.profiler")
local registry = require("nvcraft.core.registry")

--- Analyzes the performance report and provides optimization suggestions.
-- @return table A list of suggestion strings.
function M.get_optimization_suggestions()
  local report = profiler.get_performance_report()
  local suggestions = {}

  -- Suggestion 1: Check for slow plugins
  if #report.slow_plugins > 0 then
    local slow_plugin_names = {}
    for _, p in ipairs(report.slow_plugins) do
      table.insert(slow_plugin_names, p.name)
    end
    table.insert(
      suggestions,
      "The following plugins are loading slowly (>20ms): "
        .. table.concat(slow_plugin_names, ", ")
        .. ". Consider lazy-loading them on keymaps or events if you don't need them at startup."
    )
  end

  -- Suggestion 2: Check for unused modules
  -- This is a more complex feature. For now, we'll just add a placeholder suggestion.
  -- A real implementation would need to track module usage over time.
  local all_modules = registry.get_all_module_specs()
  if #all_modules > 20 then -- Arbitrary number
    table.insert(
      suggestions,
      "You have many modules enabled. Consider disabling any you don't use regularly via the Module Manager."
    )
  end

  -- Suggestion 3: General advice on lazy loading
  if #report.slow_plugins == 0 and #suggestions == 0 then
    table.insert(suggestions, "Performance seems good! For even faster startup, ensure most plugins are lazy-loaded.")
  end

  return suggestions
end

--- Displays the optimization suggestions to the user.
function M.show_suggestions()
  local suggestions = M.get_optimization_suggestions()
  if #suggestions > 0 then
    vim.notify(
      table.concat(suggestions, "\n\n"),
      vim.log.levels.INFO,
      { title = "NvCraft Performance Optimizer" }
    )
  else
    vim.notify("No specific performance optimizations to suggest at this time.", vim.log.levels.INFO, {
      title = "NvCraft Performance Optimizer",
    })
  end
end

--- Manages plugin cache, offering options to clean it.
-- @param action string Can be "clean" to clear the cache.
function M.manage_cache(action)
  if action == "clean" then
    if package.loaded["lazy"] then
      require("lazy").clean()
      vim.notify("Cleared lazy.nvim cache.", vim.log.levels.INFO, { title = "NvCraft Optimizer" })
    else
      vim.notify("lazy.nvim is not available to clean.", vim.log.levels.WARN, { title = "NvCraft Optimizer" })
    end
  end
end


return M
