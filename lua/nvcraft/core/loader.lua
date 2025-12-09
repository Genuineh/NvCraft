local M = {}

local registry = require("nvcraft.core.registry")
local _loaded_modules = {}
local failed_modules = {}

local function bind_keys(keys)
	if not keys or #keys == 0 then
		return
	end
	local km = vim.keymap
	for _, key_def in ipairs(keys) do
		local mode, lhs, rhs, opts = unpack(key_def)
		opts = opts or { noremap = true, silent = true }
		km.set(mode, lhs, rhs, opts)
	end
end

local function create_autocmds(autocmds)
	if not autocmds or #autocmds == 0 then
		return
	end
	for _, ac_def in ipairs(autocmds) do
		local event, pattern, callback = unpack(ac_def)
		vim.api.nvim_create_autocmd(event, {
			pattern = pattern,
			callback = callback,
		})
	end
end

function M.load_modules()
	local modules = registry.get_modules()
	local all_plugins = {}

	for _, module_name in ipairs(modules) do
		local spec = registry.get_module_spec(module_name)

		if spec then
			-- Check if any dependency has failed
			local can_load = true
			for _, dep in ipairs(spec.dependencies) do
				if failed_modules[dep] then
					can_load = false
					break
				end
			end

			if can_load then
				local ok, _ = pcall(function()
					-- Setup function
					if spec.setup then
						spec.setup(spec.config_schema or {}) -- Pass config schema as opts for now
					end

					-- Bind keys
					bind_keys(spec.keys)

					-- Create autocmds
					create_autocmds(spec.autocmds)

					-- Collect plugins
					for _, plugin in ipairs(spec.plugins) do
						table.insert(all_plugins, plugin)
					end
				end)

				if ok then
          _loaded_modules[module_name] = true
				else
					failed_modules[module_name] = true
					vim.notify("Failed to load module: " .. module_name, vim.log.levels.ERROR)
				end
			else
				failed_modules[module_name] = true
				vim.notify("Skipping module due to failed dependency: " .. module_name, vim.log.levels.WARN)
			end
		else
			failed_modules[module_name] = true
			vim.notify("Could not find module specification for: " .. module_name, vim.log.levels.ERROR)
		end
	end

	return all_plugins
end

return M
