local M = {}

local modules = {}

function M.discover_modules()
	-- Using the hardcoded list from the old init.lua to ensure compatibility
	-- until modules are fully refactored in Phase 3.
	modules = {
		"base",
		"mini_icons",
		"colorshceme",
		"nvimnotify",
		"noice",
		"bufferline",
		"dressing",
		"nvimspectre",
		"lazydev",
		"neotree",
		"colorful_menu",
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
		"markdown_preview",
		"images",
		"avante",
		"project",
		"snacks",
		"obsidian",
	}
end

function M.get_modules()
	return modules
end

function M.setup()
	M.discover_modules()
end

return M
