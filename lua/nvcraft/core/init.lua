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
				rocks = { "lyaml", "penlight" },
			},
		},
		-- Then, define our local core loader which depends on it.
		-- lazy.nvim will find this directory in our `lua` folder.
		{ "nvcraft-core-loader", dir = vim.fn.stdpath("config") .. "/lua/nvcraft-core-loader" },
	})
end

return M
