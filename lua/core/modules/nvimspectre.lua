return {
	-- "nvim-pack/nvim-spectre",
	-- build = false,
	-- cmd = "Spectre",
	-- opts = { open_cmd = "noswapfile vnew" },
	-- -- stylua: ignore
	-- keys = {
	--     { "<leader>rs", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
	-- },
	"MagicDuck/grug-far.nvim",
	cmd = "GrugFar",
	opts = {
		headerMaxWidth = 80,
	},
	keys = {
		{
			"<leader>sr",
			function()
				local grug = require("grug-far")
				local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
				grug.open({
					transient = true,
					prefills = {
						filesFilter = ext and ext ~= "" and "*." .. ext or nil,
					},
				})
			end,
			mode = { "n", "v" },
			desc = "Replace in files (Grug)",
		},
	},
}
