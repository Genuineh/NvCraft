local M = {}

--- Fetches the full specification for a given module.
-- This includes metadata, plugin definitions, setup functions, etc.
-- @param module_name (string) The name of the module.
-- @return (table|nil) The module specification table, or nil if loading fails.
function M.get_module_spec(module_name)
	-- Corrected path to modules
	local module_path = "nvcraft.modules." .. module_name
	local ok, module_spec = pcall(require, module_path)

	if not ok then
		-- pcall failed, module has a syntax error or doesn't exist.
		vim.notify("Failed to load module spec for: " .. module_name .. "\n" .. module_spec, vim.log.levels.ERROR)
		return nil
	end

	-- Validate and provide defaults for critical fields
	module_spec.name = module_spec.name or module_name
	module_spec.version = module_spec.version or "0.1.0"
	module_spec.dependencies = module_spec.dependencies or {}
	module_spec.plugins = module_spec.plugins or {}
	module_spec.meta = module_spec.meta or {}

	-- Ensure meta has some defaults too
	module_spec.meta.enabled_by_default = module_spec.meta.enabled_by_default ~= false

	-- Validate and provide defaults for compatibility flags
	module_spec.compatibility = module_spec.compatibility or {}

	return module_spec
end

return M
