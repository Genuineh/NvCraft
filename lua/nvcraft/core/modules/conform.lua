local setup = function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "black" },
			-- You can customize some of the format options for the filetype (:help conform.format)
			rust = { "rustfmt", lsp_format = "fallback" },

			go = { "goimports" },

			-- Conform will run the first available formatter
			javascript = { "biome", stop_after_first = true },

			typescript = { "biome", stop_after_first = true },

			-- cs = { "csharpier" },

			json = { "biome" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters = {
			injected = { options = { ignore_errors = true } },
			-- csharpier = {
			-- 	command = "dotnet-csharpier",
			-- 	args = { "--write-stdout" },
			-- },
		},
	})
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function(args)
			require("conform").format({ bufnr = args.buf })
		end,
	})
end
return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>cf",
			function()
				require("conform").format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	-- lazy = true,
	-- cmd = "ConformInfo",
	-- keys = {
	--     {
	--         "<leader>cF",
	--         function()
	--             require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
	--         end,
	--         mode = { "n", "v" },
	--         desc = "Format Injected Langs",
	--     },
	-- },
	config = setup,
}
