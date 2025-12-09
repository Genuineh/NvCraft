return {
	"rebelot/kanagawa.nvim",
	config = function()
		vim.cmd.colorscheme("kanagawa-wave")
	end,
	-- lazy = true,
}

-- return {
-- 	"jpwol/thorn.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	opts = {},
-- }

-- return {
-- 	"neanias/everforest-nvim",
-- 	version = false,
-- 	lazy = false,
-- 	priority = 1000, -- make sure to load this before all the other start plugins
-- 	-- Optional; default configuration will be used if setup isn't called.
-- 	config = function()
-- 		require("everforest").setup({
-- 			-- Your config here
-- 		})
-- 	end,
-- }
