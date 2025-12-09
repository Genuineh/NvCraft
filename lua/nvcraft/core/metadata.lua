-- Basic metadata handler
local M = {}

--- Gets the metadata for a specific module.
-- For now, this is a placeholder. A real implementation would require modules
-- to be structured in a way that metadata can be easily extracted.
-- @param module_name (string) The name of the module.
-- @return (table|nil) The metadata table, or nil if not found.
function M.get_metadata(module_name)
	local module_path = "nvcraft.modules." .. module_name
	local ok, module = pcall(require, module_path)

	if ok and module.meta then
		return module.meta
	else
		-- Fallback for old modules that don't have a meta table
		return {
			name = module_name,
			description = "A NvCraft module.",
			version = "0.1.0",
		}
	end
end

return M
