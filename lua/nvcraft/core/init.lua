local M = {}

function M.Load()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=v11.17.1", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	-- 1. Generate the complete list of plugin specifications from all NvCraft modules.
	local loader = require("nvcraft.core.loader")
	local all_plugins = loader.generate_plugin_specs()

	-- 2. Call lazy.setup() ONCE with the complete and final list of plugins.
	require("lazy").setup(all_plugins)

	-- 3. Setup user commands after lazy has been configured.
	-- We defer this to ensure all modules are available.
	vim.defer_fn(function()
		local ok, commands_mod = pcall(require, "nvcraft.modules.base.commands")
		if ok and commands_mod.setup then
			commands_mod.setup()
		else
			vim.notify("Failed to setup NvCraft user commands.", vim.log.levels.ERROR)
		end
	end, 1) -- Defer by a minimal amount
end

return M
