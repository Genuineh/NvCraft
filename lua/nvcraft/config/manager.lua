-- Basic configuration manager
local M = {}

local storage = require("nvcraft.config.storage")
local config_path = vim.fn.stdpath("config") .. "/nvcraft_config.json"

local config_cache = nil

--- Gets the configuration for a specific module, or the entire config.
-- @param module_name (string|nil) The name of the module to get config for.
--                                If nil, returns the entire configuration table.
-- @return (any) The requested configuration.
function M.get_config(module_name)
	if not config_cache then
		config_cache = storage.read_config(config_path) or {}
	end

	if module_name then
		return config_cache[module_name]
	else
		return config_cache
	end
end

--- Sets the configuration for a specific module.
-- @param module_name (string) The name of the module to set config for.
-- @param module_config (table) The configuration to set.
function M.set_config(module_name, module_config)
	if not config_cache then
		M.get_config() -- Ensure config is loaded
	end
	config_cache[module_name] = module_config
end

--- Saves the current configuration to disk.
function M.save_config()
	if config_cache then
		storage.write_config(config_path, config_cache)
	end
end

return M
