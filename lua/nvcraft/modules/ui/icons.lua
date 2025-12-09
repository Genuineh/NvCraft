return {
	name = "mini.icons",
	version = "1.0.0",
	description = "An icon system for NvCraft",
	category = "ui",
	dependencies = { "base" },

	meta = {
		author = "echasnovski",
		homepage = "https://github.com/echasnovski/mini.nvim",
		tags = { "icons", "ui" },
		enabled_by_default = true,
	},

	config_schema = {},

	plugins = {
		{
			"echasnovski/mini.icons",
			lazy = true,
			opts = {
				file = {
					[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
					["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
				},
				filetype = {
					dotenv = { glyph = "", hl = "MiniIconsYellow" },
				},
			},
			init = function()
				package.preload["nvim-web-devicons"] = function()
					require("mini.icons").mock_nvim_web_devicons()
					return package.loaded["nvim-web-devicons"]
				end
			end,
		},
	},

  setup = function(_opts)
		-- No direct setup needed for this module, handled by lazy.nvim
	end,

	keys = {},
	autocmds = {},

	health_check = function()
		-- TODO: Implement health check for mini.icons
	end,
}
