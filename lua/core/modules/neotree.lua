return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		{
			"s1n7ax/nvim-window-picker",
			version = "2.*",
			config = function()
				require("window-picker").setup({
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { "neo-tree", "neo-tree-popup", "notify" },
							-- if the buffer type is one of following, the window will be ignored
							buftype = { "terminal", "quickfix" },
						},
					},
				})
			end,
		},
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	-- init = function()
	--     if vim.fn.argc(-1) == 1 then
	--         local stat = vim.loop.fs_stat(vim.fn.argv(0))
	--         if stat and stat.type == "directory" then
	--             require("neo-tree")
	--         end
	--     end
	-- end,
	opts = {
		sources = { "filesystem", "buffers", "git_status", "document_symbols" },
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = {
				enabled = true,
				-- leave_dir_open = true,
			},
			use_libuv_file_watcher = true,
			commands = {
				trash = function(state)
					local inputs = require("neo-tree.ui.inputs")
					local path = state.tree:get_node().path
					local utils = require("neo-tree.utils")
					local _, name = utils.split_path(path)

					local msg = string.format("Are you sure you want to trash '%s'?", name)

					inputs.confirm(msg, function(confirmed)
						if not confirmed then
							return
						end

						pcall(function()
							vim.fn.system({ "trash", vim.fn.fnameescape(path) })
							if vim.v.shell_error ~= 0 then
								msg = "trash command failed."
								vim.notify(msg, vim.log.levels.ERROR, { title = "Neo-tree" })
							end
						end)

						require("neo-tree.sources.manager").refresh(state.name)
					end)
				end,

				trash_visual = function(state, selected_nodes)
					local inputs = require("neo-tree.ui.inputs")
					local msg = "Are you sure you want to trash " .. #selected_nodes .. " files ?"

					inputs.confirm(msg, function(confirmed)
						if not confirmed then
							return
						end

						for _, node in ipairs(selected_nodes) do
							pcall(function()
								vim.fn.system({ "trash", vim.fn.fnameescape(node.path) })
								if vim.v.shell_error ~= 0 then
									msg = "trash command failed."
									vim.notify(msg, vim.log.levels.ERROR, { title = "Neo-tree" })
								end
							end)
						end

						require("neo-tree.sources.manager").refresh(state.name)
					end)
				end,
			},
		},
		window = {
			position = "float",
			mappings = {
				["<space>"] = "none",
				["w"] = "open_with_window_picker",
				["l"] = "open",
				-- ["p"] = { "toggle_preview", config = { use_float = false } },
				["h"] = "close_node",
				["Y"] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					vim.fn.setreg("+", path, "c")
				end,
				["d"] = "delete",
				["D"] = "trash",
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			git_status = {
				symbols = {
					unstaged = "󰄱",
					staged = "󰱒",
				},
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)
		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "*lazygit",
			callback = function()
				if package.loaded["neo-tree.sources.git_status"] then
					require("neo-tree.sources.git_status").refresh()
				end
			end,
		})
	end,
	keys = {
		{
			"<leader>e",
			function()
				local runtime = require("core.runtime")
				if runtime.root == nil or runtime.root == "" then
					print("No root")
				end
				require("neo-tree.command").execute({ toggle = true, dir = runtime.root })
				-- require("neo-tree.command").execute({ toggle = true, dir = vim.fn.expand("%:p:h") })
			end,
			desc = "Toggle NeoTree (cwd)",
		},
		{
			"<leader>eg",
			function()
				require("neo-tree.command").execute({ source = "git_status", toggle = true })
			end,
			desc = "Toggle NeoTree (git)",
		},
		{
			"<leader>eb",
			function()
				require("neo-tree.command").execute({ source = "buffers", toggle = true })
			end,
			desc = "Buffer Explorer",
		},
	},
	init = function()
		-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
		-- because `cwd` is not set up properly.
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
			desc = "Start Neo-tree with directory",
			once = true,
			callback = function()
				if package.loaded["neo-tree"] then
					return
				else
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == "directory" then
						require("neo-tree")
					end
				end
			end,
		})
	end,
}
