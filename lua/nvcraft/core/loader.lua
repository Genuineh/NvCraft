-- This file is responsible for translating the NvCraft module format
-- into a format that lazy.nvim can understand and manage.
local M = {}

local registry = require("nvcraft.core.registry")
local failed_modules = {}

--- Translates NvCraft module specs into lazy.nvim plugin specs and adds them.
function M.load_modules()
	local modules_to_load = registry.get_modules()
	local all_plugin_specs = {}

	for _, module_name in ipairs(modules_to_load) do
		-- Skip the special modules that are handled by the core loader itself.
		if module_name == "base.luarocks" or module_name == "base.commands" then
			goto continue
		end

		local spec = registry.get_module_spec(module_name)
		if not spec then
			failed_modules[module_name] = true
			vim.notify("Could not find module specification for: " .. module_name, vim.log.levels.ERROR)
			goto continue
		end

		-- 1. Add the actual plugins defined in the module
		local module_plugin_names = {}
		if spec.plugins and #spec.plugins > 0 then
			for _, plugin_spec in ipairs(spec.plugins) do
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

	-- Add all the generated specs to lazy.nvim at once
	if #all_plugin_specs > 0 then
		require("lazy").add(all_plugin_specs)
	end

	-- After adding all plugins dynamically, we need to tell lazy to process them
	-- and load any that should have been loaded on startup events.
	require("lazy").sync({ notify = false })
end

return M
