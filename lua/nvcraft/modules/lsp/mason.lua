local default_on_attach = function(client, buf)
	-- Enable completion triggered by <c-x><c-o>
	-- vim.bo[buf].omnifunc = "v:lua.vim.lsp.omnifunc"
	-- { "gd", "<cmd>FzfLua lsp_definitions jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto Definition" },
	-- { "gr", "<cmd>FzfLua lsp_references jump_to_single_result=true ignore_current_line=true<cr>", desc = "References" },
	-- { "gI", "<cmd>FzfLua lsp_implementations jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto Implementation" },
	-- { "gy", "<cmd>FzfLua lsp_typedefs jump_to_single_result=true ignore_current_line=true<cr>", desc = "Goto T[y]pe Definition" },
	-- Buffer local mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local opts = { buffer = buf }
	vim.keymap.set("n", "gd", "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>", opts)
	vim.keymap.set("n", "gD", "<cmd>FzfLua lsp_declarations jump1=true ignore_current_line=true<cr>", opts)
	vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>", opts)

	vim.keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", opts)

	vim.keymap.set("n", "gy", "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>", opts)

	if client.name == "omnisharp" then
		vim.keymap.set("n", "gd", function()
			require("omnisharp_extended").lsp_definitions()
		end, opts)
		-- else
		-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	else
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	end
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	-- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	-- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)

	if client.name == "roslyn" or client.name == "roslyn_ls" then
		vim.api.nvim_create_autocmd("InsertCharPre", {
			desc = "Roslyn: Trigger an auto insert on '/'.",
			buffer = buf,
			callback = function()
				local char = vim.v.char

				if char ~= "/" then
					return
				end

				local row, col = unpack(vim.api.nvim_win_get_cursor(0))
				row, col = row - 1, col + 1
				local uri = vim.uri_from_bufnr(buf)

				local params = {
					_vs_textDocument = { uri = uri },
					_vs_position = { line = row, character = col },
					_vs_ch = char,
					_vs_options = {
						tabSize = vim.bo[buf].tabstop,
						insertSpaces = vim.bo[buf].expandtab,
					},
				}

				-- NOTE: We should send textDocument/_vs_onAutoInsert request only after
				-- buffer has changed.
				vim.defer_fn(function()
					client:request(
						---@diagnostic disable-next-line: param-type-mismatch
						"textDocument/_vs_onAutoInsert",
						params,
						function(err, result, _)
							if err or not result then
								return
							end

							vim.snippet.expand(result._vs_textEdit.newText)
						end,
						buf
					)
				end, 1)
			end,
		})

		vim.api.nvim_create_autocmd({ "InsertLeave" }, {
			pattern = "*",
			callback = function()
				local clients = vim.lsp.get_clients({ name = "roslyn" })
				if not clients or #clients == 0 then
					return
				end

				local buffers = vim.lsp.get_buffers_by_client_id(client.request)
				for _, buffer_id in ipairs(buffers) do
					local params = { textDocument = vim.lsp.util.make_text_document_params(buffer_id) }
					client:request("textDocument/diagnostic", params, nil, buffer_id)
				end
			end,
		})
	end
end

local setup = function()
	--like
	vim.lsp.set_log_level("off")
	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
			"gopls",
			"html",
			"cssls",
			"ts_ls",
			"pyright",
			"jsonls",
			-- "vimls",
			"clangd",
			-- "roslyn",
			-- format
			-- "csharpier",
			-- "marksman",
		},
	})

	-- Set up lspconfig.
	-- change by cmp plugin
	-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
	local capabilities = require("blink.cmp").get_lsp_capabilities()

	vim.lsp.config["luals"] = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
		on_attach = default_on_attach,
		capabilities = capabilities,
	}
	vim.lsp.enable("luals")

	vim.lsp.config["clangd"] = {
		-- root_dir = function(fname)
		-- 	return require("lspconfig.util").root_pattern(
		-- 		"Makefile",
		-- 		"configure.ac",
		-- 		"configure.in",
		-- 		"config.h.in",
		-- 		"meson.build",
		-- 		"meson_options.txt",
		-- 		"build.ninja"
		-- 	)(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(fname) or require(
		-- 		"lspconfig.util"
		-- 	).find_git_ancestor(fname)
		-- end,
		init_options = {
			usePlaceholders = true,
			completeUnimported = true,
			clangdFileStatus = true,
		},
		cmd = {
			"clangd",
			"-j=2",
			"--background-index",
			"--clang-tidy",
			"--pch-storage=disk",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--fallback-style=llvm",
			"--malloc-trim",
		},
		on_attach = default_on_attach,
		capabilities = capabilities,
	}
	vim.lsp.enable("clangd")

	vim.lsp.config["pyright"] = {
		on_attach = default_on_attach,
		capabilities = capabilities,
		settings = {
			python = {
				pythonPath = vim.fn.exepath("python"),
			},
		},
	}
	vim.lsp.enable("pyright")

	vim.lsp.config["tl_ls"] = {
		on_attach = default_on_attach,
		capabilities = capabilities,
	}
	vim.lsp.enable("tl_ls")

	vim.lsp.config["html"] = {
		on_attach = default_on_attach,
		capabilities = capabilities,
	}
	vim.lsp.enable("html")

	vim.lsp.config["cssls"] = {
		on_attach = default_on_attach,
		capabilities = capabilities,
	}
	vim.lsp.enable("cssls")

	vim.lsp.config["gopls"] = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
				gofumpt = true,
			},
		},
		on_attach = default_on_attach,
		capabilities = capabilities,
	}
	vim.lsp.enable("gopls")

	vim.lsp.config["rust_analyzer"] = {
		on_attach = default_on_attach,
		capabilities = capabilities,
	}
	vim.lsp.enable("rust_analyzer")

	vim.lsp.config["roslyn"] = {
		on_attach = default_on_attach,
		capabilities = capabilities,
		settings = {
			["csharp|inlay_hints"] = {
				csharp_enable_inlay_hints_for_implicit_object_creation = true,
				csharp_enable_inlay_hints_for_implicit_variable_types = true,
				csharp_enable_inlay_hints_for_lambda_parameter_types = true,
				csharp_enable_inlay_hints_for_types = true,
				dotnet_enable_inlay_hints_for_indexer_parameters = true,
				dotnet_enable_inlay_hints_for_literal_parameters = true,
				dotnet_enable_inlay_hints_for_object_creation_parameters = true,
				dotnet_enable_inlay_hints_for_other_parameters = true,
				dotnet_enable_inlay_hints_for_parameters = true,
				dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
				dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
				dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
			},
			["csharp|code_lens"] = {
				dotnet_enable_references_code_lens = true,
			},
			["csharp|symbol_search"] = {
				dotnet_search_reference_assemblies = true,
			},
			["csharp|background_analysis"] = {
				dotnet_analyzer_diagnostics_scope = "fullSolution",
				dotnet_compiler_diagnostics_scope = "fullSolution",
			},
			["csharp|completion"] = {
				dotnet_show_name_completion_suggestions = true,
				dotnet_show_completion_items_from_unimported_namespaces = true,
				dotnet_provide_regex_completions = true,
			},
		},
	}
	vim.lsp.enable("roslyn")

	local handles = {}
	-- roslyn autocmd
	vim.api.nvim_create_autocmd("User", {
		pattern = "RoslynRestoreProgress",
		callback = function(ev)
			local token = ev.data.params[1]
			local handle = handles[token]
			if handle then
				handle:report({
					title = ev.data.params[2].state,
					message = ev.data.params[2].message,
				})
			else
				handles[token] = require("fidget.progress").handle.create({
					title = ev.data.params[2].state,
					message = ev.data.params[2].message,
					lsp_client = {
						name = "roslyn",
					},
				})
			end
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "RoslynRestoreResult",
		callback = function(ev)
			local handle = handles[ev.data.token]
			handles[ev.data.token] = nil

			if handle then
				handle.message = ev.data.err and ev.data.err.message or "Restore completed"
				handle:finish()
			end
		end,
	})

	vim.api.nvim_create_user_command("CSFixUsings", function()
		local bufnr = vim.api.nvim_get_current_buf()

		local clients = vim.lsp.get_clients({ name = "roslyn" })
		if not clients or vim.tbl_isempty(clients) then
			vim.notify("Couldn't find client", vim.log.levels.ERROR, { title = "Roslyn" })
			return
		end

		local client = clients[1]
		local action = {
			kind = "quickfix",
			data = {
				CustomTags = { "RemoveUnnecessaryImports" },
				TextDocument = { uri = vim.uri_from_bufnr(bufnr) },
				CodeActionPath = { "Remove unnecessary usings" },
				Range = {
					["start"] = { line = 0, character = 0 },
					["end"] = { line = 0, character = 0 },
				},
				UniqueIdentifier = "Remove unnecessary usings",
			},
		}

		client:request("codeAction/resolve", action, function(err, resolved_action)
			if err then
				vim.notify("Fix using directives failed", vim.log.levels.ERROR, { title = "Roslyn" })
				return
			end
			vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
		end)
	end, { desc = "Remove unnecessary using directives" })
end

return {
	"neovim/nvim-lspconfig",
	event = "LazyFile",
	dependencies = {
		-- { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
		{ "folke/neoconf.nvim", cmd = "Neoconf", config = false },
		-- {
		--     "folke/neodev.nvim",
		--     opts = {},
		--     config = function()
		--         require("neodev").setup({
		--             library = { plugins = { "neotest" }, types = true },
		--         })
		--     end,
		-- },
		"saghen/blink.cmp",
		{
			"seblyng/roslyn.nvim",
			-- ft = "cs",
			opts = {
				-- config = {
				-- on_attach = default_on_attach,
				-- settings = {
				-- 	["csharp|inlay_hints"] = {
				-- 		csharp_enable_inlay_hints_for_implicit_object_creation = true,
				-- 		csharp_enable_inlay_hints_for_implicit_variable_types = true,
				-- 		csharp_enable_inlay_hints_for_lambda_parameter_types = true,
				-- 		csharp_enable_inlay_hints_for_types = true,
				-- 		dotnet_enable_inlay_hints_for_indexer_parameters = true,
				-- 		dotnet_enable_inlay_hints_for_literal_parameters = true,
				-- 		dotnet_enable_inlay_hints_for_object_creation_parameters = true,
				-- 		dotnet_enable_inlay_hints_for_other_parameters = true,
				-- 		dotnet_enable_inlay_hints_for_parameters = true,
				-- 		dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
				-- 		dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
				-- 		dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
				-- 	},
				-- 	["csharp|code_lens"] = {
				-- 		dotnet_enable_references_code_lens = true,
				-- 	},
				-- },
				-- },
			},
		},
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		-- "Hoffs/omnisharp-extended-lsp.nvim",
		"saghen/blink.cmp",
		"p00f/clangd_extensions.nvim",
	},
	config = setup,
	keys = {
		{
			"<leader>rl",
			"<cmd>LspRestart<cr>",
			desc = "Restart LSP",
		},
	},
}
