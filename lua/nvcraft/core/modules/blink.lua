local _opts = {
	-- 'default' for mappings similar to built-in completion
	-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
	-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
	-- See the full "keymap" documentation for information on defining your own keymap.
	keymap = {
		preset = "default",
		["<S-Tab>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<C-e>"] = {},
	},

	appearance = {
		-- Sets the fallback highlight groups to nvim-cmp's highlight groups
		-- Useful for when your theme doesn't support blink.cmp
		-- Will be removed in a future release
		use_nvim_cmp_as_default = false,
		-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		list = { selection = {
			preselect = function(ctx)
				return ctx.mode ~= "cmdline"
			end,
		} },
		menu = {
			auto_show = function(ctx)
				return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
			end,
			draw = {
				treesitter = { "lsp" },
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind" },
				},
				-- components = {
				-- 	label = {
				-- 		text = function(ctx)
				-- 			return require("colorful-menu").blink_components_text(ctx)
				-- 		end,
				-- 		highlight = function(ctx)
				-- 			return require("colorful-menu").blink_components_highlight(ctx)
				-- 		end,
				-- 	},
				-- },
			},
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
		},
		ghost_text = {
			enabled = true,
		},
	},

	snippets = { preset = "luasnip" },

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		-- completion = {
		-- 	enabled_providers = { "codecompanion" },
		-- },
		compat = {},
		default = { "avante", "lsp", "path", "snippets", "lazydev", "copilot", "buffer", "omni" },
		-- default = { "lsp", "path", "snippets", "lazydev", "codecompanion", "buffer" },
		providers = {
			lazydev = {
				name = "lazydev",
				module = "lazydev.integrations.blink",
				score_offset = 100, -- show at a higher priority than lsp
			},
			-- codecompanion = {
			-- 	name = "CodeCompanion",
			-- 	module = "codecompanion.providers.completion.blink",
			-- 	-- kind = "Copilot",
			-- 	score_offset = 100,
			-- 	-- async = true,
			-- 	enabled = true,
			-- },
			copilot = {
				name = "copilot",
				module = "blink-cmp-copilot",
				kind = "Copilot",
				score_offset = 100, -- show at a higher priority than lsp
				async = true,
				enabled = true,
			},
			avante = {
				name = "Avante",
				module = "blink-cmp-avante",
				kind = "Avante",
			},
		},
		-- per_filetype = {
		-- 	codecompanion = { "codecompanion" },
		-- },
		-- cmdline = {},
	},
}

local setup = function(_, opts)
	-- setup compat sources
	local enabled = opts.sources.default
	for _, source in ipairs(opts.sources.compat or {}) do
		opts.sources.providers[source] = vim.tbl_deep_extend(
			"force",
			{ name = source, module = "blink.compat.source" },
			opts.sources.providers[source] or {}
		)
		if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
			table.insert(enabled, source)
		end
	end

	-- Unset custom prop to pass blink.cmp validation
	opts.sources.compat = nil

	-- check if we need to override symbol kinds
	for _, provider in pairs(opts.sources.providers or {}) do
		---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
		if provider.kind then
			local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
			local kind_idx = #CompletionItemKind + 1

			CompletionItemKind[kind_idx] = provider.kind
			---@diagnostic disable-next-line: no-unknown
			CompletionItemKind[provider.kind] = kind_idx

			---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
			local transform_items = provider.transform_items
			---@param ctx blink.cmp.Context
			---@param items blink.cmp.CompletionItem[]
			provider.transform_items = function(ctx, items)
				items = transform_items and transform_items(ctx, items) or items
				for _, item in ipairs(items) do
					item.kind = kind_idx or item.kind
				end
				return items
			end

			-- Unset custom prop to pass blink.cmp validation
			provider.kind = nil
		end
	end

	require("blink.cmp").setup(opts)
end

return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	-- optional: provides snippets for the snippet source
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
			build = "make install_jsregexp",
			config = function(_, opts)
				if opts then
					require("luasnip").config.setup(opts)
				end
				vim.tbl_map(function(type)
					require("luasnip.loaders.from_" .. type).lazy_load()
				end, { "vscode", "snipmate", "lua" })
				-- require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip").filetype_extend("typescript", { "tsdoc" })
				require("luasnip").filetype_extend("javascript", { "jsdoc" })
				require("luasnip").filetype_extend("lua", { "luadoc" })
				require("luasnip").filetype_extend("python", { "pydoc" })
				require("luasnip").filetype_extend("rust", { "rustdoc" })
				require("luasnip").filetype_extend("cs", { "csharpdoc" })
				require("luasnip").filetype_extend("java", { "javadoc" })
				require("luasnip").filetype_extend("c", { "cdoc" })
				require("luasnip").filetype_extend("cpp", { "cppdoc" })
				require("luasnip").filetype_extend("php", { "phpdoc" })
				require("luasnip").filetype_extend("kotlin", { "kdoc" })
				require("luasnip").filetype_extend("ruby", { "rdoc" })
				require("luasnip").filetype_extend("sh", { "shelldoc" })
			end,
		},
		{
			"saghen/blink.compat",
			opts = {},
			version = "*",
		},
		"giuxtaposition/blink-cmp-copilot",
		after = {
			"copilot.lua",
		},
		"Kaiser-Yang/blink-cmp-avante",
	},

	-- use a release tag to download pre-built binaries
	-- version = "*"
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = "cargo build --release",
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	opts = _opts,
	opts_extend = {
		-- "source.completion.enable_providers",
		"source.compat",
		"sources.default",
	},
	config = setup,
}
