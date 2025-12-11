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

	-- Define all plugins, including our local core loader
	local plugins = {
		-- First, define the dependency
		{
			"vhyrro/luarocks.nvim",
			opts = {
				rocks = { "lyaml", "schema-validation" },
			},
		},
		-- Then, define our core loader which depends on it.
		-- lazy.nvim will automatically load this from the runtime path.
		require("nvcraft.core.loader_plugin"),
	}

	require("lazy").setup(plugins)
end

return M
