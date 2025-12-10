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

return M
