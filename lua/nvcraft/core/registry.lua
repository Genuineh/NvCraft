local M = {}

local metadata = require("nvcraft.core.metadata")
local modules = {}
local module_specs = {}

local function topological_sort(dependencies)
	local sorted = {}
	local visited = {}
	local in_stack = {}

	local function visit(module_name)
		if in_stack[module_name] then
			vim.notify("Cyclic dependency detected in modules: " .. module_name, vim.log.levels.ERROR)
			return false
		end

		if not visited[module_name] then
			visited[module_name] = true
			in_stack[module_name] = true

			local deps = dependencies[module_name]
			if deps then
				for _, dep in ipairs(deps) do
					if not visit(dep) then
						return false
					end
				end
			end

			table.insert(sorted, module_name)
			in_stack[module_name] = false
		end

		return true
	end

	for module_name, _ in pairs(dependencies) do
		if not visited[module_name] then
			if not visit(module_name) then
				return nil -- Cyclic dependency found
			end
		end
	end

	return sorted
end

function M.discover_modules()
	local modules_path = "lua/nvcraft/core/modules"
	local files = vim.fn.readdir(modules_path)

	local discovered_modules = {}
	for _, file in ipairs(files) do
		if file:match("%.lua$") then
			local module_name = file:gsub("%.lua$", "")
			table.insert(discovered_modules, module_name)
		end
	end

	-- Build dependency graph
	local dependencies = {}
	for _, module_name in ipairs(discovered_modules) do
		local spec = metadata.get_module_spec(module_name)
		if spec then
			module_specs[module_name] = spec
			dependencies[module_name] = spec.dependencies
		end
	end

	-- Perform topological sort
	local sorted_modules = topological_sort(dependencies)
	if sorted_modules then
		modules = sorted_modules
	else
		-- Fallback to unsorted list in case of cyclic dependency
		modules = discovered_modules
		vim.notify("Could not sort modules by dependency, loading in default order.", vim.log.levels.WARN)
	end
end

function M.get_modules()
	return modules
end

function M.get_module_spec(module_name)
	return module_specs[module_name]
end

function M.setup()
	M.discover_modules()
end

return M
