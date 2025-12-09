require("nvcraft.core.modules")
local options = function()
	local opt = vim.opt

	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- 设置行号
	opt.relativenumber = true
	opt.number = true

	-- 缩进
	opt.tabstop = 4
	opt.shiftwidth = 4
	opt.expandtab = true
	opt.autoindent = true

	-- 防止代码包裹
	-- opt.wrap = true

	-- 光标行
	opt.cursorline = true

	-- 启用鼠标
	opt.mouse:append("a")

	-- 系统剪切板
	opt.clipboard:append("unnamedplus")
	vim.g.clipboard = {
		name = "wl-clipboard",
		copy = {
			["+"] = "wl-copy --foreground --type text/plain",
			["*"] = "wl-copy --foreground --primary --type text/plain",
		},
		paste = {
			["+"] = "wl-paste --no-newline",
			["*"] = "wl-paste --no-newline --primary",
		},
		cache_enabled = true,
	}

	-- 默认新窗口右和下
	opt.splitright = true
	opt.splitbelow = true

	-- 设置搜索
	opt.ignorecase = true
	opt.smartcase = true

	-- 外观
	opt.termguicolors = true
	opt.signcolumn = "yes"

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "dart", "json", "cpp", "h", "hpp" },
		callback = function()
			vim.opt.tabstop = 2
			vim.opt.shiftwidth = 2
		end,
	})

	-- fold
	opt.foldmethod = "expr"
	opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	opt.foldlevel = 99
	-- vim.opt.foldlevelstart = 1

	-- 自动折行
	-- opt.warp = true

	-- views can only be fully collapsed with the global statusline
	opt.laststatus = 3
	opt.splitkeep = "screen"
end

return {
	"base",
	opts = options,
	keys = {
		keys_create("i", "jk", "<Esc>"),
		keys_create("v", "J", ":m '>+1<CR>gv=gv"),
		keys_create("v", "K", ":m '<-2<CR>gv=gv"),
		keys_create("n", "<leader>sv", "<C-w>v"),
		keys_create("n", "<leader>sh", "<C-w>s"),
		keys_create("n", "<leader>nh", ":nohl<CR>"),
		keys_create("n", "<leader>q", ":q<CR>"),
		keys_create("n", "<leader>s", ":w<CR>"),
		keys_create("n", "<leader>h", "<C-w>h"),
		keys_create("n", "<leader>l", "<C-w>l"),
		keys_create("n", "<leader>j", "<C-w>j"),
		keys_create("n", "<leader>k", "<C-w>k"),
		keys_create("n", "<leader>wwi", "<C-w>>"),
		keys_create("n", "<leader>wwd", "<C-w><"),
		keys_create("n", "<leader>whi", "<C-w>+"),
		keys_create("n", "<leader>whd", "<C-w>-"),
	},
	config = function() end,
}
