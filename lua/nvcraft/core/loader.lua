local M = {}

local registry = require("nvcraft.core.registry")

local function bind_keys(keys)
	if not keys then
		return
	end
	local km = vim.keymap
	for i = 1, #keys do
		local opt = keys[i][4]
		if opt == nil then
			opt = { noremap = true, silent = true }
		end
		km.set(keys[i][1], keys[i][2], keys[i][3], opt)
	end
end

function M.load_modules(path)
	local modules = registry.get_modules()
	local plugins = {}
	local base_module = {}
	local modules_dir = path .. ".modules" -- Corrected path

	for _, module_name in ipairs(modules) do
		local module_path = modules_dir .. "." .. module_name
		local ok, module = pcall(require, module_path)

		if ok then
			if module_name == "base" then
				base_module = module
			else
				table.insert(plugins, module)
			end
		else
			vim.notify("Failed to load module: " .. module_name .. "\n" .. module, vim.log.levels.ERROR)
		end
	end

	-- Handle base module setup separately
	if base_module.opts then
		base_module.opts()
	end
	bind_keys(base_module.keys)

	return plugins
end

return M
