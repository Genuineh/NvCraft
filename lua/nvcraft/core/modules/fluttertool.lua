local default_on_attach = function(_, buf)
	-- Enable completion triggered by <c-x><c-o>
	-- vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Buffer local mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local opts = { buffer = buf }
	-- if client.name == "omnisharp" then
	-- 	vim.keymap.set("n", "gd", function()
	-- 		require("omnisharp_extended").lsp_definitions()
	-- 	end, opts)
	-- else
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	-- end
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
end

return {
	"nvim-flutter/flutter-tools.nvim",
	event = "LazyFile",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- optional for vim.ui.select
	},
	ft = "dart",
	config = function()
		-- function _G.statusLine()
		-- 	return vim.g.flutter_tools_decorations.app_version
		-- end
		--
		-- vim.opt.statusline = "%!v:statusLine()"

		-- Set up lspconfig.
		-- change by cmp plugin
		-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		require("flutter-tools").setup({
			flutter_path = "/home/jerryg/fvm/default/bin/flutter",
			lsp = {
				on_attach = default_on_attach,
				capabilities = capabilities,
				settings = {
					-- analysisExcludedFolders = { "/home/jerryg/.pub-cache" },
				},
				color = { -- show the derived colours for dart variables
					enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
					background = false, -- highlight the background
					background_color = nil, -- required, when background is transparent
					foreground = false, -- highlight the foreground
					virtual_text = true, -- show the highlight using virtual text
					virtual_text_str = "■", -- the virtual text character to highlight
				},
			},
			debugger = {
				enabled = true,
				register_configuration = function()
					local dap = require("dap")
					dap.configurations.dart = {}
					require("dap.ext.vscode").load_launchjs()
					-- dap.adapters.dart = {
					-- 	type = "executable",
					-- 	command = "dart",
					-- 	args = { "debug_adapter" },
					-- }
					--
					-- dap.adapters.flutter = {
					-- 	type = "executable",
					-- 	command = "flutter",
					-- 	args = { "debug_adapter" },
					-- }
					-- dap.configurations.dart = {
					-- 	{
					-- 		type = "dart",
					-- 		request = "launch",
					-- 		name = "Launch dart",
					-- 		dartSdkPath = "/home/jerryg/fvm/default/bin/dart", -- ensure this is correct
					-- 		flutterSdkPath = "/home/jerryg/fvm/default/bin/flutter", -- ensure this is correct
					-- 		program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
					-- 		cwd = "${workspaceFolder}",
					-- 	},
					-- 	{
					-- 		type = "flutter",
					-- 		request = "launch",
					-- 		name = "Launch flutter",
					-- 		dartSdkPath = "/home/jerryg/fvm/default/bin/dart", -- ensure this is correct
					-- 		flutterSdkPath = "/home/jerryg/fvm/default/bin/flutter", -- ensure this is correct
					-- 		program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
					-- 		cwd = "${workspaceFolder}",
					-- 	},
					-- }
				end,
			},
			decorations = {
				statusline = {
					app_version = true,
					device = true,
				},
			},
		})

		-- require("flutter-tools").setup_project({
		-- 	name = "Development",
		-- 	target = "lib/main.dart",
		-- 	dart_define_from_file = "dart-define.json",
		-- })
		-- code
	end,
}
