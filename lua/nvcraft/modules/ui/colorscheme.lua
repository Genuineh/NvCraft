return {
  name = "colorscheme",
  version = "1.0.0",
  description = "Manages the colorscheme for NvCraft.",
  category = "ui",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "colorscheme", "theme" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "rebelot/kanagawa.nvim",
      config = function()
        vim.cmd.colorscheme("kanagawa-wave")
      end,
      -- lazy = true,
    },

    -- {
    -- 	"jpwol/thorn.nvim",
    -- 	lazy = false,
    -- 	priority = 1000,
    -- 	opts = {},
    -- },

    -- {
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
    -- },
  },
}
