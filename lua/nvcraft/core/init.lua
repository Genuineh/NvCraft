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
		{
			"vhyrro/luarocks.nvim",
			opts = {
				rocks = { "lyaml", "schema-validation" },
			},
		},
		{
			name = "nvcraft-core-loader",
			dependencies = { "luarocks.nvim" },
			config = function()
				-- Now that luarocks.nvim is loaded, we can safely require modules that need it.
				local registry = require("nvcraft.core.registry")
				registry.setup()

				local loader = require("nvcraft.core.loader")
				loader.load_modules()
			end,
		},
	})
end

return M
