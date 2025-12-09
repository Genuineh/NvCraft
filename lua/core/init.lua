local M = {}

local _modules = {
	"base",
	"mini_icons",
	"colorshceme",
	-- "dashboard",
	"nvimnotify",
	"noice",
	"bufferline",
	"dressing",
	"nvimspectre",
	"lazydev",
	"neotree",
	"colorful_menu",
	-- "copilot",
	"blink",
	"mason",
	"nvim_lint",
	"conform",
	"comment",
	"which_key",
	"autopairs",
	"lazygit",
	"persistence",
	"lualine",
	"nvim_treesitter",
	"trouble",
	"fzf",
	-- "project",
	"dap",
	"toggleterm",
	"neotest",
	"gitsigns",
	"flash",
	"vimilluminate",
	"outline",
	"fluttertool",
	"smear_cursor",
	"edgy",
	-- "headlines",
	"markdown_preview",
	"images",
	"avante",
	"project",
	"snacks",
	"obsidian",
}

local function get_modules_names()
	return _modules
end

-- lazy vim
function init_lazy(plugins)
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=v11.17.1", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)
	require("utils.plugin").lazy_file()
	require("lazy").setup(plugins)
end

local function bind_keys(keys)
	local km = vim.keymap
	for i = 1, #keys do
		local opt = keys[i][4]
		if opt == nil then
			opt = {
				noremap = true,
				silent = true,
			}
		end
		km.set(keys[i][1], keys[i][2], keys[i][3], opt)
	end
end

local function get_modules(path, modules)
	local res = {}
	local base = {}
	for i = 1, #modules do
		local m_path = path .. "." .. modules[i]
		if modules[i] == "base" then
			base = require(m_path)
		else
			local m_path = path .. "." .. modules[i]
			local m = require(m_path)
			table.insert(res, m)
		end
	end
	return { base, res }
end

local function init_base(basePlugin)
	basePlugin.opts()
	bind_keys(basePlugin.keys)
end

function M.Load(path)
	local runtime = require("core.runtime")
	runtime.setup(get_modules_names())
	local modules_dir = path .. ".modules"
	local ms = get_modules_names()
	local plugins = get_modules(modules_dir, ms)
	init_base(plugins[1])
	init_lazy(plugins[2])
end

return M
