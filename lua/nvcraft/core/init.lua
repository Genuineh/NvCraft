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
			config = function(_, opts)
				-- Setup luarocks before doing anything else
				require("luarocks.nvim").setup(opts)

				-- Now that luarocks.nvim is loaded and configured, we can safely
				-- proceed with loading the rest of NvCraft.
				local registry = require("nvcraft.core.registry")
				registry.setup()

				local loader = require("nvcraft.core.loader")
				loader.load_modules()
			end,
		},
	})
end

return M
