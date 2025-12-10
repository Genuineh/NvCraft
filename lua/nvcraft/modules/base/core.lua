return {
	name = "base",
	version = "1.0.0",
	description = "Core settings for NvCraft",
	category = "base",
	dependencies = {},

	-- 元数据
	meta = {
		author = "NvCraft",
		homepage = "https://github.com/NvCraft/NvCraft",
		tags = { "core", "base" },
		enabled_by_default = true,
	},

	-- 配置 Schema
	config_schema = {},

	-- 插件定义
	plugins = {},

	-- 设置函数
  setup = function(_opts)
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
	end,

	-- 按键绑定
	keys = {
		{ "i", "jk", "<Esc>" },
		{ "v", "J", ":m '>+1<CR>gv=gv" },
		{ "v", "K", ":m '<-2<CR>gv=gv" },
		{ "n", "<leader>sv", "<C-w>v" },
		{ "n", "<leader>sh", "<C-w>s" },
		{ "n", "<leader>nh", ":nohl<CR>" },
		{ "n", "<leader>q", ":q<CR>" },
		{ "n", "<leader>s", ":w<CR>" },
		{ "n", "<leader>h", "<C-w>h" },
		{ "n", "<leader>l", "<C-w>l" },
		{ "n", "<leader>j", "<C-w>j" },
		{ "n", "<leader>k", "<C-w>k" },
		{ "n", "<leader>wwi", "<C-w>>" },
		{ "n", "<leader>wwd", "<C-w><" },
		{ "n", "<leader>whi", "<C-w>+" },
		{ "n", "<leader>whd", "<C-w>-" },
	},

	-- 自动命令
	autocmds = {
		{
			"FileType",
			pattern = { "dart", "json", "cpp", "h", "hpp" },
			callback = function()
				vim.opt.tabstop = 2
				vim.opt.shiftwidth = 2
			end,
		},
	},

	-- 健康检查
	health_check = function()
    return {
      name = "Base Module",
      status = "OK",
      message = "Core settings are loaded.",
    }
	end,
}
