local pick = nil

local set_project_root = function(path)
	local runtime = require("core.runtime")
	runtime.set_project_root(path)
end

local change_root = function()
	local current_path = vim.fn.expand("%:p")
	set_project_root(current_path)
end

local select = function(selected, opts)
	local fzf = require("fzf-lua")
	local entry = fzf.path.entry_to_file(selected[1], opts, opts._uri)
	local fullpath = entry.bufname or entry.uri and entry.uri:match("^%a+://(.*)") or entry.path
	set_project_root(fullpath)
	return fzf.actions.file_edit_or_qf(selected, opts)
end

pick = function()
	local runtime = require("core.runtime")
	if runtime.modules_has("fzf") then
		local fzf_lua = require("fzf-lua")
		-- local project = require("project_nvim.project")
		local history = require("project_nvim.utils.history")
		-- local project = require("project_nvim")
		local results = history.get_recent_projects()
		local utils = require("fzf-lua.utils")

		local function hl_validate(hl)
			return not utils.is_hl_cleared(hl) and hl or nil
		end

		local function ansi_from_hl(hl, s)
			return utils.ansi_from_hl(hl_validate(hl), s)
		end

		local opts = {
			fzf_opts = {
				["--header"] = string.format(
					":: <%s> to %s | <%s> to %s | <%s> to %s | <%s> to %s",
					ansi_from_hl("FzfLuaHeaderBind", "ctrl-t"),
					ansi_from_hl("FzfLuaHeaderText", "tabedit"),
					ansi_from_hl("FzfLuaHeaderBind", "ctrl-s"),
					ansi_from_hl("FzfLuaHeaderText", "live_grep"),
					ansi_from_hl("FzfLuaHeaderBind", "ctrl-r"),
					ansi_from_hl("FzfLuaHeaderText", "oldfiles"),
					-- ansi_from_hl("FzfLuaHeaderBind", "ctrl-w"),
					-- ansi_from_hl("FzfLuaHeaderText", "change_dir"),
					ansi_from_hl("FzfLuaHeaderBind", "ctrl-d"),
					ansi_from_hl("FzfLuaHeaderText", "delete")
				),
			},
			fzf_colors = true,
			actions = {
				["default"] = {
					function(selected)
						fzf_lua.files({
							actions = {
								["default"] = select,
							},
							cwd = selected[1],
						})
					end,
				},
				["ctrl-t"] = {
					function(selected)
						vim.cmd("tabedit")
						fzf_lua.files({ cwd = selected[1] })
					end,
				},
				["ctrl-s"] = {
					function(selected)
						fzf_lua.live_grep({ cwd = selected[1] })
					end,
				},
				["ctrl-r"] = {
					function(selected)
						fzf_lua.oldfiles({ cwd = selected[1] })
					end,
				},
				-- ["ctrl-b"] = {
				-- 	function(selected)
				-- 		local path = selected[1]
				-- 		local ok = project.set_pwd(path)
				-- 		if ok then
				-- 			require("core.runtime").set_project_root(path)
				-- 			vim.api.nvim_win_close(0, false)
				-- 			-- LazyVim.info("Change project dir to " .. path)
				-- 		end
				-- 	end,
				-- },
				["ctrl-d"] = function(selected)
					local path = selected[1]
					local choice = vim.fn.confirm("Delete '" .. path .. "' project? ", "&Yes\n&No")
					if choice == 1 then
						history.delete_project({ value = path })
					end
					pick()
				end,
			},
		}

		fzf_lua.fzf_exec(results, opts)
	end
end

local _opts = {
	-- Manual mode doesn't automatically change your root directory, so you have
	-- the option to manually do so using `:ProjectRoot` command.
	manual_mode = false,

	-- Methods of detecting the root directory. **"lsp"** uses the native neovim
	-- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
	-- order matters: if one is not detected, the other is used as fallback. You
	-- can also delete or rearangne the detection methods.
	detection_methods = { "lsp", "pattern" },

	-- All the patterns used to detect root dir, when **"pattern"** is in
	-- detection_methods
	patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "*.sln" },

	-- Table of lsp clients to ignore by name
	-- eg: { "efm", ... }
	ignore_lsp = {},

	-- Don't calculate root dir on specific directories
	-- Ex: { "~/.cargo/*", ... }
	exclude_dirs = {},

	show_hidden = false,

	-- When set to false, you will get a message when project.nvim changes your
	-- directory.
	silent_chdir = true,

	-- What scope to change the directory, valid options are
	-- * global (default)
	-- * tab
	-- * win
	scope_chdir = "global",

	-- Path where project.nvim will store the project history for use in
	datapath = vim.fn.stdpath("data"),
}

local setup = function(_, opts)
	require("project_nvim").setup(opts)
	local history = require("project_nvim.utils.history")
	history.delete_project = function(project)
		for k, v in pairs(history.recent_projects) do
			if v == project.value then
				history.recent_projects[k] = nil
				return
			end
		end
	end
	-- require("snacks.dashboard").preset.keys.insert(3, {
	-- 	action = pick,
	-- 	desc = " Projects",
	-- 	icon = " ",
	-- 	key = "p",
	-- })
end

return {
	"ahmedkhalf/project.nvim",
	-- event = "VeryLazy",
	-- opts = _opts,
	opts = _opts,
	config = setup,
	dependencies = {
		{
			"ibhagwan/fzf-lua",
			keys = {
				{ "<leader>fp", pick, desc = "Projects" },
				{ "<leader>rc", change_root, desc = "Root change" },
			},
		},
		-- {
		-- "nvimdev/dashboard-nvim",
		-- opts = function(_, opts)
		-- 	require("snacks").opts.dashboard.preset.keys.insert(3, {
		-- 		action = pick,
		-- 		desc = " Projects",
		-- 		icon = " ",
		-- 		key = "p",
		-- 	})
		-- 	-- if not vim.tbl_get(opts, "config", "center") then
		-- 	-- 	return
		-- 	-- end
		-- 	-- local projects = {
		-- 	-- 	action = pick,
		-- 	-- 	desc = " Projects",
		-- 	-- 	icon = " ",
		-- 	-- 	key = "p",
		-- 	-- }
		-- 	--
		-- 	-- projects.desc = projects.desc .. string.rep(" ", 43 - #projects.desc)
		-- 	-- projects.key_format = "  %s"
		--
		-- 	-- table.insert(opts.config.center, 3, projects)
		-- end,
		-- },
	},
	pick_func = pick,
}
