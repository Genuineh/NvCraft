local M = {}

local detector = require("nvcraft.smart.detector")
local registry = require("nvcraft.core.registry")

--- A mapping from project types/languages to recommended modules.
-- This should be expanded over time.
local recommendation_map = {
  -- Project types
  git = { "git.signs", "git.lazygit" },
  node = { "lsp.servers", "lsp.formatter", "tools.testing" },
  rust = { "lsp.servers", "lsp.formatter", "tools.testing", "lsp.dap" },
  python = { "lsp.servers", "lsp.formatter", "tools.testing", "lsp.dap" },
  go = { "lsp.servers", "lsp.formatter", "tools.testing", "lsp.dap" },

  -- Languages (can also map to modules)
  Lua = { "lsp.servers" },
  TypeScript = { "lsp.servers" },
  JavaScript = { "lsp.servers" },
}

--- Recommends modules based on detected project properties.
-- @return table A list of recommended module names that are not already enabled.
function M.recommend_modules()
  local project_types = detector.detect_project_type()
  local languages = detector.detect_languages()
  local recommendations = {}
  local recommended_set = {}

  local all_modules = registry.get_all_module_specs()
  local enabled_modules = {}
  for module_name, spec in pairs(all_modules) do
    if spec.enabled_by_default ~= false then -- Consider modules enabled unless explicitly disabled
      enabled_modules[module_name] = true
    end
  end


  -- Add recommendations based on project type
  for _, p_type in ipairs(project_types) do
    local mods = recommendation_map[p_type]
    if mods then
      for _, mod_name in ipairs(mods) do
        if not recommended_set[mod_name] and not enabled_modules[mod_name] then
          table.insert(recommendations, mod_name)
          recommended_set[mod_name] = true
        end
      end
    end
  end

  -- Add recommendations based on language
  for _, lang in ipairs(languages) do
    local mods = recommendation_map[lang]
    if mods then
      for _, mod_name in ipairs(mods) do
        if not recommended_set[mod_name] and not enabled_modules[mod_name] then
          table.insert(recommendations, mod_name)
          recommended_set[mod_name] = true
        end
      end
    end
  end

  return recommendations
end

--- Detects potential conflicts between enabled modules.
-- @return table A list of conflict description strings.
function M.detect_plugin_conflicts()
  local conflicts = {}
  local all_modules = registry.get_all_module_specs()
  local enabled_modules = {}

  for name, spec in pairs(all_modules) do
    if spec.enabled_by_default ~= false then
      table.insert(enabled_modules, name)
    end
  end

  -- Conflict check example: multiple Git modules
  local git_modules = {}
  for _, name in ipairs(enabled_modules) do
    if name:match("^git.") then
      table.insert(git_modules, name)
    end
  end
  if #git_modules > 1 then
    table.insert(
      conflicts,
      "Multiple Git modules are enabled (" .. table.concat(git_modules, ", ") .. "). This may cause unexpected behavior."
    )
  end

  -- Conflict check example: multiple fuzzy finders
  local fuzzy_finders = {}
  local fuzzy_map = {
    ["files.fuzzy"] = "fzf",
  }
  for _, name in ipairs(enabled_modules) do
    if fuzzy_map[name] then
      table.insert(fuzzy_finders, fuzzy_map[name])
    end
  end
  if #fuzzy_finders > 1 then
    table.insert(
      conflicts,
      "Multiple fuzzy finders detected (" .. table.concat(fuzzy_finders, ", ") .. "). Consider choosing one."
    )
  end

  return conflicts
end


--- Provides configuration optimization suggestions based on usage habits.
-- This is a placeholder for a more complex implementation that would track feature usage.
-- @return table A list of suggestion strings.
function M.optimize_config_by_usage()
  local suggestions = {}
  local all_modules = registry.get_all_module_specs()

  -- Simple check: if a user has many modules, suggest a review.
  local enabled_count = 0
  for _, spec in pairs(all_modules) do
    if spec.enabled_by_default ~= false then
      enabled_count = enabled_count + 1
    end
  end

  if enabled_count > 15 then -- Arbitrary threshold for "many" modules
    table.insert(
      suggestions,
      "You have "
        .. enabled_count
        .. " modules enabled. Review them with `:NvCraftModuleManager` to disable any you don't use."
    )
  end

  -- Future idea: track command usage frequency or LSP client attachments
  -- to suggest disabling unused features within modules.

  return suggestions
end

return M
