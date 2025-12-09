local M = {}

local registry = require("nvcraft.core.registry")
local _loaded_modules = {}
local failed_modules = {}

-- Store autocmd group IDs for each module to allow unloading
local _module_augroup_ids = {}

local function unbind_keys(keys)
	if not keys or #keys == 0 then
		return
	end
	local km = vim.keymap
	for _, key_def in ipairs(keys) do
		local mode, lhs = unpack(key_def)
		-- pcall in case the keymap doesn't exist
		pcall(km.del, mode, lhs)
	end
end

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

local function create_autocmds(module_name, autocmds)
	if not autocmds or #autocmds == 0 then
		return
	end
	-- Create a dedicated augroup for the module
	local group_name = "nvcraft_module_" .. module_name
	local group_id = vim.api.nvim_create_augroup(group_name, { clear = true })
	_module_augroup_ids[module_name] = group_id

	for _, ac_def in ipairs(autocmds) do
		local event, pattern, callback = unpack(ac_def)
		vim.api.nvim_create_autocmd(event, {
			group = group_id,
			pattern = pattern,
			callback = callback,
		})
	end
end

--- Unloads a module's configuration.
function M.unload_module(module_name)
	local spec = _loaded_modules[module_name]
	if not spec then
		return
	end

	-- Run teardown function if it exists
	if spec.teardown then
		pcall(spec.teardown)
	end

	-- Clear autocmds
	local group_id = _module_augroup_ids[module_name]
	if group_id then
		vim.api.nvim_clear_autocmds({ group = group_id })
		_module_augroup_ids[module_name] = nil
	end

	-- Unbind keys
	unbind_keys(spec.keys)

	_loaded_modules[module_name] = nil
	-- Clear the module from Lua's cache
	package.loaded["nvcraft.core.modules." .. module_name] = nil
	vim.notify("Unloaded module: " .. module_name)
end

--- Loads a single module.
-- @return (boolean, table) success, module_plugins
function M.load_module(module_name)
	if _loaded_modules[module_name] then
		return true, {}
	end

	local spec = registry.get_module_spec(module_name)
	local plugins = {}
	if not spec then
		failed_modules[module_name] = true
		vim.notify("Could not find module specification for: " .. module_name, vim.log.levels.ERROR)
		return false, {}
	end

	-- Check for compatibility
	if spec.compatibility then
		if spec.compatibility.neovim and not vim.fn.has("nvim-" .. spec.compatibility.neovim) then
			vim.notify(
				"Module "
					.. module_name
					.. " requires Neovim >= "
					.. spec.compatibility.neovim
					.. ". Skipping.",
				vim.log.levels.WARN
			)
			return false, {}
		end
	end

	-- Check if any dependency has failed
	for _, dep in ipairs(spec.dependencies) do
		if failed_modules[dep] or not _loaded_modules[dep] then
			failed_modules[module_name] = true
			vim.notify("Skipping module due to missing or failed dependency '" .. dep .. "': " .. module_name, vim.log.levels.WARN)
			return false, {}
		end
	end

	local ok, _ = pcall(function()
		-- Setup function
		if spec.setup then
			spec.setup(spec.config_schema or {}) -- Pass config schema as opts for now
		end

		-- Bind keys
		bind_keys(spec.keys)

		-- Create autocmds
		create_autocmds(module_name, spec.autocmds)

		-- Collect plugins
		plugins = spec.plugins or {}
	end)

	if ok then
		_loaded_modules[module_name] = spec
	else
		failed_modules[module_name] = true
		vim.notify("Failed to load module: " .. module_name, vim.log.levels.ERROR)
		return false, {}
	end

	return true, plugins
end


--- Hot-reloads a module.
function M.reload_module(module_name)
	vim.notify("Reloading module: " .. module_name)
	M.unload_module(module_name)

	local metadata = require("nvcraft.core.metadata")
	metadata.get_module_spec(module_name) -- This re-requires and caches the new spec

	local ok, _ = M.load_module(module_name)

	if ok then
		vim.notify("Successfully reloaded module: " .. module_name)
	else
		vim.notify("Failed to reload module: " .. module_name, vim.log.levels.ERROR)
	end
end


function M.load_modules()
	local modules_to_load = registry.get_modules()
	local all_plugins = {}
	local lazy_load_triggers = {}

	for _, module_name in ipairs(modules_to_load) do
		local spec = registry.get_module_spec(module_name)
		if spec then
			-- Always collect plugins for lazy.nvim to handle
			for _, plugin in ipairs(spec.plugins or {}) do
				table.insert(all_plugins, plugin)
			end

			if spec.lazy then
				-- Handle lazy loading triggers
				if spec.trigger and spec.trigger.event then
					local events = type(spec.trigger.event) == "table" and spec.trigger.event or { spec.trigger.event }
					for _, event in ipairs(events) do
						table.insert(lazy_load_triggers, {
							event = event,
							pattern = spec.trigger.pattern or "*",
							module = module_name,
						})
					end
				end
				if spec.trigger and spec.trigger.cmd then
					-- Create a command that loads the module
					local cmds = type(spec.trigger.cmd) == "table" and spec.trigger.cmd or { spec.trigger.cmd }
					for _, cmd in ipairs(cmds) do
						vim.api.nvim_create_user_command(cmd, function()
							M.load_module(module_name)
						end, {})
					end
				end
			else
				-- Load immediately
				M.load_module(module_name)
			end
		else
			failed_modules[module_name] = true
			vim.notify("Could not find module specification for: " .. module_name, vim.log.levels.ERROR)
		end
	end

	-- Setup autocmds for lazy loading modules
	if #lazy_load_triggers > 0 then
		local lazy_loader_group = vim.api.nvim_create_augroup("NvCraftLazyLoader", { clear = true })
		for _, trigger in ipairs(lazy_load_triggers) do
			vim.api.nvim_create_autocmd(trigger.event, {
				group = lazy_loader_group,
				pattern = trigger.pattern,
				callback = function()
					M.load_module(trigger.module)
				end,
				once = true,
			})
		end
	end

	return all_plugins
end

return M
