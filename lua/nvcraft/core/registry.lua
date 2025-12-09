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
    local modules_path = "lua/nvcraft/modules"
    local discovered_modules = {}

    local function scan_dir(path)
        local files = vim.fn.readdir(path)
        for _, file in ipairs(files) do
            local full_path = path .. "/" .. file
            if file ~= "." and file ~= ".." then
                if vim.fn.isdirectory(full_path) == 1 then
                    scan_dir(full_path)
                elseif file:match("%.lua$") then
                    local module_name = full_path:gsub(modules_path .. "/", ""):gsub("%.lua$", ""):gsub("/", ".")
                    table.insert(discovered_modules, module_name)
                end
            end
        end
    end

    scan_dir(modules_path)

	-- Build dependency graph
	local dependencies = {}
	for _, module_name in ipairs(discovered_modules) do
		local spec = metadata.get_module_spec(module_name)
		if spec then
			module_specs[module_name] = spec
			dependencies[module_name] = spec.dependencies
		end
	end

	-- Check for version compatibility
	for module_name, spec in pairs(module_specs) do
		for _, dep_name in ipairs(spec.dependencies) do
			local dep_spec = module_specs[dep_name]
			if dep_spec and not M.check_version_compatibility(spec, dep_spec) then
				vim.notify(
					"Version mismatch for module "
						.. module_name
						.. ": requires "
						.. dep_name
						.. " version "
						.. (spec.dependency_versions[dep_name] or "any")
						.. ", but found "
						.. dep_spec.version,
					vim.log.levels.WARN
				)
			end
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

--- Checks if a dependent module's version is compatible.
-- @param dependent_spec (table) The module spec that has the dependency.
-- @param dependency_spec (table) The module spec of the dependency.
-- @return (boolean) True if compatible, false otherwise.
function M.check_version_compatibility(dependent_spec, dependency_spec)
	local required_version = dependent_spec.dependency_versions and dependent_spec.dependency_versions[dependency_spec.name]
	if not required_version then
		return true -- No specific version required
	end
	return dependency_spec.version == required_version
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
