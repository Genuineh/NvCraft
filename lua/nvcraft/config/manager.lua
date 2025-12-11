--- Hierarchical configuration manager with validation and import/export capabilities.
local M = {}

local storage = require("nvcraft.config.storage")
local util = require("nvcraft.util")
local schema_def = require("nvcraft.config.schema")
local migration = require("nvcraft.config.migration")

local validator = nil -- Defer initialization

local function get_validator()
	if not validator then
		local ok, pl = pcall(require, "pl.schema")
		if ok then
			validator = pl
		else
			vim.notify("Could not load 'penlight'. Please restart Neovim.", vim.log.levels.ERROR)
			-- Return a dummy validator to prevent further errors
			validator = {
				check = function()
					return true, "penlight not loaded"
				end,
			}
		end
	end
	return validator
end

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

	-- Run migrations on the user's config before merging
	local user_config_migrated = migration.migrate_config(user_config)
	if user_config_migrated ~= user_config then
		storage.write_config(config_paths.user, user_config_migrated)
		user_config = user_config_migrated
	end

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

	-- Start watching config files for changes
	M.watch_config_files()

	return config_cache
end

--- Callback function for reloading the config when a file changes.
local function on_config_change(file_path)
	vim.notify("Configuration file changed: " .. file_path .. ". Reloading...", vim.log.levels.INFO)
	M.load_config()
end

--- Starts watching the user and project config files.
function M.watch_config_files()
	storage.watch_file(config_paths.user, on_config_change)
	storage.watch_file(config_paths.project, on_config_change)
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
	-- No need to explicitly reload; the file watcher will handle it.
end

--- Validates the configuration against the defined schema.
-- @param config (table) The configuration to validate.
-- @return (boolean) True if the config is valid, false otherwise.
function M.validate_config(config)
	local v = get_validator()
	local ok, err = v.check(config, schema_def.schema)
	if not ok then
		vim.notify("Configuration validation failed:\n" .. tostring(err), vim.log.levels.ERROR)
		return false
	end
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
