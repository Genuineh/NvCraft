-- This file is responsible for discovering all NvCraft modules and translating
-- them into a single, complete list of lazy.nvim plugin specifications.
local M = {}

local registry = require("nvcraft.core.registry")

--- Discovers all modules and returns a list of lazy.nvim plugin specs.
-- @return table A list of plugin specifications for lazy.nvim.
function M.generate_plugin_specs()
	-- First, discover all modules to build the registry.
	registry.setup()
	local modules_to_load = registry.get_modules()
	local all_plugin_specs = {}

	-- Manually add essential plugins like luarocks first.
	table.insert(
		all_plugin_specs,
		{
			"vhyrro/luarocks.nvim",
			opts = {
				rocks = { "lyaml", "penlight" },
			},
		}
	)

	for _, module_name in ipairs(modules_to_load) do
		local spec = registry.get_module_spec(module_name)
		if not spec then
			vim.notify("Could not find module specification for: " .. module_name, vim.log.levels.ERROR)
			goto continue
		end

		-- 1. Add the actual plugins defined in the module
		local module_plugin_names = {}
		if spec.plugins and #spec.plugins > 0 then
			for _, plugin_spec in ipairs(spec.plugins)
				table.insert(all_plugin_specs, plugin_spec)
				-- Keep track of plugin names to use in dependencies
				if type(plugin_spec) == "table" and type(plugin_spec[1]) == "string" then
					table.insert(module_plugin_names, plugin_spec[1])
				elseif type(plugin_spec) == "string" then
					table.insert(module_plugin_names, plugin_spec)
				end
			end
		end

		-- 2. Create a virtual plugin to handle the module's own runtime configuration
		local has_runtime_config = spec.setup or spec.keys or spec.autocmds
		if has_runtime_config then
			local runtime_spec = {
				name = "nvcraft-runtime-" .. spec.name,
				dependencies = module_plugin_names,
				config = spec.setup,
				keys = spec.keys,
				init = function()
					if spec.autocmds and #spec.autocmds > 0 then
						local group_name = "nvcraft_module_autocmds_" .. spec.name
						local group_id = vim.api.nvim_create_augroup(group_name, { clear = true })
						for _, ac_def in ipairs(spec.autocmds) do
							local event, pattern, callback = unpack(ac_def)
							vim.api.nvim_create_autocmd(event, {
								group = group_id,
								pattern = pattern,
								callback = callback,
							})
						end
					end
				end,
			}
			table.insert(all_plugin_specs, runtime_spec)
		end
		::continue::
	end

	return all_plugin_specs
end

return M
