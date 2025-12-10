local M = {}

local profiler = require("nvcraft.smart.profiler")
local registry = require("nvcraft.core.registry")

--- Analyzes the performance report and provides optimization suggestions.
-- @return table A list of suggestion strings.
function M.get_optimization_suggestions()
  local report = profiler.get_performance_report()
  local suggestions = {}

  -- Suggestion 1: More specific advice for slow plugins
  if #report.slow_plugins > 0 then
    for _, p in ipairs(report.slow_plugins) do
      local suggestion = string.format(
        "Plugin '%s' took %.2fms to load. If you don't need it at startup, consider lazy-loading it on an event, command, or keymap.",
        p.name,
        p.load_time
      )
      table.insert(suggestions, suggestion)
    end
  end

  -- Suggestion 2: Combine with recommender's usage-based suggestions
  local usage_suggestions = require("nvcraft.smart.recommender").optimize_config_by_usage()
  for _, s in ipairs(usage_suggestions) do
    table.insert(suggestions, s)
  end

  -- Suggestion 3: General advice if no other issues are found
  if #suggestions == 0 then
    table.insert(
      suggestions,
      "Overall performance is good. You can always review your enabled modules with `:NvCraftModuleManager`."
    )
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
-- @param action string Can be "clean" or "clean_all".
function M.manage_cache(action)
  if action == "clean" or action == "clean_all" then
    if package.loaded["lazy"] then
      require("lazy").clean()
      vim.notify("Cleared lazy.nvim cache.", vim.log.levels.INFO, { title = "NvCraft Optimizer" })
    else
      vim.notify("lazy.nvim is not available to clean.", vim.log.levels.WARN, { title = "NvCraft Optimizer" })
    end
  end

  if action == "clean_all" then
    -- Also clean plenary cache if it exists
    pcall(function()
      local plenary_cache = require("plenary.path").new(vim.fn.stdpath("cache"), "plenary")
      if plenary_cache:exists() then
        plenary_cache:rmrf()
        vim.notify("Cleared plenary.nvim cache.", vim.log.levels.INFO, { title = "NvCraft Optimizer" })
      end
    end)
  end
end


return M
