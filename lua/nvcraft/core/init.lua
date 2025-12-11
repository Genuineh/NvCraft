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

	require("lazy").setup({
		-- First, define the dependency
		{
			"vhyrro/luarocks.nvim",
			opts = {
				rocks = { "lyaml", "schema-validation" },
			},
		},
		-- Then, define our local core loader which depends on it.
		-- This is a local plugin spec, not a remote repository.
		{
			name = "nvcraft-core",
			dependencies = { "vhyrro/luarocks.nvim" },
			config = function()
				-- By the time this runs, luarocks.nvim is ready.
				local registry = require("nvcraft.core.registry")
				registry.setup()

				local loader = require("nvcraft.core.loader")
				loader.load_modules()

				-- And finally, setup the commands module now that everything else is loaded.
				local ok, commands_mod = pcall(require, "nvcraft.modules.base.commands")
				if ok and commands_mod.setup then
					commands_mod.setup()
				else
					vim.notify("Failed to setup NvCraft user commands.", vim.log.levels.ERROR)
				end
			end,
		},
	})
end

return M
