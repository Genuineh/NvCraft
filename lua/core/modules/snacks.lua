local dashboard_opt = {
	header = [[
            ██╗███████╗██████╗ ██████╗ ██╗   ██╗  ✨
        ██║██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
       ██║█████╗  ██████╔╝██████╔╝ ╚████╔╝
 ██   ██║██╔══╝  ██╔══██╗██╔══██╗  ╚██╔╝
╚█████╔╝███████╗██║  ██║██║  ██║   ██║
 ╚════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
]],
	keys = {
		{ action = ":FzfLua files", desc = " Find file", icon = " ", key = "ff" },
		{ action = ":FzfLua files cwd=~/Work/ ", desc = " Find file in Work", icon = " ", key = "fiw" },
		{ action = ":FzfLua files cwd=~/github/ ", desc = " Find file in github", icon = " ", key = "fig" },
		{
			action = function()
				local project = require("core.modules.project")
				project.pick_func()
			end,
			desc = " Projects",
			icon = " ",
			key = "p",
		},
		{ action = ":ene | startinsert", desc = " New file", icon = " ", key = "n" },
		{ action = ":FzfLua oldfiles", desc = " Recent files", icon = " ", key = "r" },
		{ action = ":FzfLua live_grep", desc = " Find text", icon = " ", key = "g" },
		{
			action = ':lua require("persistence").load({ last = true })',
			desc = " Restore Session",
			icon = " ",
			key = "s",
		},
		{ action = ":Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
		{ action = ":qa", desc = " Quit", icon = " ", key = "q" },
	},
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		-- bigfile = { enabled = true },
		dashboard = { enabled = true, preset = dashboard_opt },
		-- terminal = { enabled = true },
		-- explorer = { enabled = true },
		-- indent = { enabled = true },
		-- input = { enabled = true },
		-- picker = { enabled = true },
		-- notifier = { enabled = true },
		-- quickfile = { enabled = true },
		-- scope = { enabled = true },
		-- scroll = { enabled = true },
		-- statuscolumn = { enabled = true },
		-- words = { enabled = true },
	},
}
