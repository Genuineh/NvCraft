--- Hierarchical configuration manager with validation and import/export capabilities.
local M = {}

local storage = require("nvcraft.config.storage")
local util = require("nvcraft.util")

-- Configuration file paths
local config_paths = {
  defaults = "nvcraft.config.defaults", -- Default settings within the distribution
  global = vim.fn.stdpath("config") .. "/nvcraft_config.json",
  user = vim.fn.stdpath("config") .. "/user_config.json", -- For user overrides
  project = vim.fn.getcwd() .. "/.nvcraft.json",
}

local config_cache = nil

--- Loads and merges configurations from all defined paths.
-- @return (table) The fully merged configuration.
function M.load_config()
  local default_config = {}
  -- Default config is loaded as a Lua table directly
  local ok, default_module = pcall(require, config_paths.defaults)
  if ok then
    if type(default_module) == "function" then
      default_config = default_module()
    elseif type(default_module) == "table" then
      default_config = default_module
    end
  end

  local global_config = storage.read_config(config_paths.global) or {}
  local user_config = storage.read_config(config_paths.user) or {}
  local project_config = storage.read_config(config_paths.project) or {}

  -- The order of merging is important: project > user > global > defaults
  local merged_config = util.deep_merge(default_config, global_config)
  merged_config = util.deep_merge(merged_config, user_config)
  config_cache = util.deep_merge(merged_config, project_config)

  -- Validate the final configuration
  if not M.validate_config(config_cache) then
    vim.notify("Configuration validation failed. Please check your settings.", vim.log.levels.ERROR)
    -- In a more robust implementation, we might fall back to a safe default.
    -- For now, we'll just log the error and continue with the possibly invalid config.
  end

  return config_cache
end

--- Gets the configuration for a specific module, or the entire config.
-- @param module_name (string|nil) The name of the module to get config for.
--                                If nil, returns the entire configuration table.
-- @return (any) The requested configuration.
function M.get_config(module_name)
  if not config_cache then
    M.load_config()
  end

  if module_name then
    return config_cache[module_name]
  else
    return config_cache
  end
end

--- Sets the configuration for a specific module in the user config.
-- @param module_name (string) The name of the module to set config for.
-- @param module_config (table) The configuration to set.
function M.set_config(module_name, module_config)
  local user_conf = storage.read_config(config_paths.user) or {}
  user_conf[module_name] = module_config
  storage.write_config(config_paths.user, user_conf)
  M.load_config() -- Reload config to apply changes
end

--- Validates the configuration.
-- For now, this is a basic check. A schema-based validation is planned.
-- @param config (table) The configuration to validate.
-- @return (boolean) True if the config is valid, false otherwise.
function M.validate_config(config)
  if type(config) ~= "table" then
    return false
  end
  -- TODO: Implement schema-based validation.
  -- For now, we're just checking that the top-level config is a table.
  return true
end

--- Exports the current user configuration to a file.
-- @param file_path (string) The path to export the configuration to.
-- @return (boolean) True on success, false on failure.
function M.export_config(file_path)
  local user_conf = storage.read_config(config_paths.user) or {}
  return storage.write_config(file_path, user_conf)
end

--- Imports a configuration from a file, overwriting user settings.
-- @param file_path (string) The path of the file to import.
-- @return (boolean) True on success, false on failure.
function M.import_config(file_path)
  local imported_conf = storage.read_config(file_path)
  if imported_conf and M.validate_config(imported_conf) then
    storage.write_config(config_paths.user, imported_conf)
    M.load_config() -- Reload to apply the new config
    return true
  else
    vim.notify("Failed to import configuration from " .. file_path, vim.log.levels.ERROR)
    return false
  end
end

return M
