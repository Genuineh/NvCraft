local M = {}

local function init_lazy(plugins)
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
	require("lazy").setup(plugins)
end

function M.Load(path)
	-- 1. Discover modules
	local registry = require("nvcraft.core.registry")
	registry.setup()

	-- 2. Load modules and collect plugins
	local loader = require("nvcraft.core.loader")
	local plugins = loader.load_modules(path)

	-- 3. Initialize lazy.nvim with the collected plugins
	init_lazy(plugins)
end

return M
