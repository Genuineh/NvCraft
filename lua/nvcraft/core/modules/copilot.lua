-- return {
-- 	"olimorris/codecompanion.nvim",
-- 	dependencies = {
-- 		{
-- 			"zbirenbaum/copilot.lua",
-- 			cmd = "Copilot",
-- 			build = ":Copilot auth",
-- 			opts = {
-- 				suggestion = { enabled = false },
-- 				panel = { enabled = false },
-- 				filetypes = {
-- 					markdown = true,
-- 					help = true,
-- 				},
-- 			},
-- 		},
-- 		"nvim-lua/plenary.nvim",
-- 		"nvim-treesitter/nvim-treesitter",
-- 		"saghen/blink.cmp",
-- 	},
-- 	opts = {
-- 		--Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
-- 		strategies = {
-- 			--NOTE: Change the adapter as required
-- 			chat = {
-- 				adapter = "copilot",
-- 				-- roles = {
-- 				-- 	-- I'm using hardcoded roles because there is another issue for llm-dynamic role for custom adapter.
-- 				-- 	llm = " Assistant",
-- 				-- 	user = " User",
-- 				-- },
-- 			},
-- 			inline = { adapter = "copilot" },
-- 		},
-- 		display = {
-- 			chat = {
-- 				show_settings = true, -- I'm using this to prove that the default model is not changed.
-- 			},
-- 		},
-- 		opts = {
-- 			log_level = "DEBUG",
-- 		},
-- 	},
-- 	keys = {
-- 		{
-- 			"<leader>at",
-- 			"<cmd>CodeCompanionChat Toggle<cr>",
-- 			desc = "Toggle (CodeCompanionChat)",
-- 			mode = { "n", "v" },
-- 		},
-- 		{
-- 			"<leader>aa",
-- 			"<cmd>CodeCompanionChat Add<cr>",
-- 			desc = "Add (CodeCompanionChat)",
-- 			mode = { "n", "v" },
-- 		},
-- 		{
-- 			"<leader>ac",
-- 			"<cmd>CodeCompanionActions<cr>",
-- 			desc = "Actions (CodeCompanionChat)",
-- 			mode = { "n", "v" },
-- 		},
-- 	},
-- }

return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		cmd = "CopilotChat",
		dependencies = {
			{
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				build = ":Copilot auth",
				opts = {
					suggestion = { enabled = false },
					panel = { enabled = false },
					filetypes = {
						markdown = true,
						help = true,
					},
				},
			},
			{
				"nvim-lua/plenary.nvim",
			},
		},
		opts = function()
			local user = vim.env.USER or "User"
			user = user:sub(1, 1):upper() .. user:sub(2)
			return {
				model = "claude-3.7-sonnet",
				auto_insert_mode = true,
				question_header = "  " .. user .. " ",
				answer_header = "  Copilot ",
				window = {
					width = 0.4,
				},
			}
		end,
		config = function(_, opts)
			local chat = require("CopilotChat")
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-chat",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})
			chat.setup(opts)
		end,
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>at",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			-- lazy.nvim keys
			-- Quick chat with Copilot
			{
				"<leader>ccq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},

			-- { "<leader>ap", M.pick("prompt"), desc = "Prompt Actions (CopilotChat)", mode = { "n", "v" } },
			{ "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
		},
	},

	-- "zbirenbaum/copilot.lua",
	-- cmd = "Copilot",
	-- build = ":Copilot auth",
	-- opts = {
	--     suggestion = { enabled = false },
	--     panel = { enabled = false },
	--     filetypes = {
	--         markdown = true,
	--         help = true,
	--     },
	-- },
}
