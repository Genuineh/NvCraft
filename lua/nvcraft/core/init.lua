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

function M.Load()
	-- 1. Initialize lazy.nvim with essential plugins first (like luarocks)
	local luarocks_spec = require("nvcraft.modules.base.luarocks")
	init_lazy(luarocks_spec.plugins)

	-- 2. Now that lazy is setup, discover and load all other modules
	vim.schedule(function()
		local registry = require("nvcraft.core.registry")
		registry.setup()

		local loader = require("nvcraft.core.loader")
		loader.load_modules()
	end)
end

return M
