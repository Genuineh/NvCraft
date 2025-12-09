--- Configuration migration utility for NvCraft.
local M = {}

-- The current version of the configuration.
-- This should be incremented whenever a breaking change is made to the config structure.
M.CURRENT_VERSION = 1

--- A registry of migration functions.
-- Each function is responsible for migrating from one version to the next.
-- The key is the version to migrate from.
local storage = require("nvcraft.config.storage")

local migrations = {
  [0] = function(config)
    -- Migration from YAML to JSON
    local old_paths = {
      global = vim.fn.stdpath("config") .. "/nvcraft_config.yml",
      user = vim.fn.stdpath("config") .. "/user_config.yml",
      project = vim.fn.getcwd() .. "/.nvcraft.yml",
    }
    local new_paths = {
      global = vim.fn.stdpath("config") .. "/nvcraft_config.json",
      user = vim.fn.stdpath("config") .. "/user_config.json",
      project = vim.fn.getcwd() .. "/.nvcraft.json",
    }

    for key, old_path in pairs(old_paths) do
      if vim.fn.filereadable(old_path) == 1 then
        local yaml_config = storage.read_config(old_path)
        if yaml_config then
          storage.write_config(new_paths[key], yaml_config)
          os.remove(old_path)
          vim.notify("Migrated " .. old_path .. " to " .. new_paths[key], vim.log.levels.INFO)
        end
      end
    end
    config.version = 1
    return config
  end,
}

--- Checks the configuration version and applies migrations if necessary.
-- @param config (table) The configuration to check and migrate.
-- @return (table) The migrated configuration.
function M.migrate_config(config)
  local config_version = config.version or 0
  if config_version >= M.CURRENT_VERSION then
    return config -- No migration needed
  end

  vim.notify(
    string.format("Outdated configuration detected (v%d). Migrating to v%d...", config_version, M.CURRENT_VERSION),
    vim.log.levels.INFO
  )

  local migrated_config = config
  for v = config_version, M.CURRENT_VERSION - 1 do
    if migrations[v] then
      migrated_config = migrations[v](migrated_config)
    else
      vim.notify(string.format("No migration found for version %d. Migration may be incomplete.", v), vim.log.levels.WARN)
    end
  end

  migrated_config.version = M.CURRENT_VERSION
  vim.notify("Configuration migration successful.", vim.log.levels.INFO)
  return migrated_config
end

return M
