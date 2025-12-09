require("utils.modules")

local options = function()
	--like
	--vim.g.loaded_netrw = 1
	--vim.g.loaded_netrwPlugin = 1
end

local setup = function()
	--like
	--require("nvim-tree").setup({
	-- })
end

local get_keys_bind = function()
	--like
	--return {
	--keys_create("i", "jk", "<Esc>"),
	--keys_create("v", "J", ":m '>+1<CR>gv=gv"),
	--}
end

local get_plugins = function()
	--like
	--return {
	--    {
	--        "2nthony/vitesse.nvim",
	--        dependencies = {
	--            "tjdevries/colorbuddy.nvim"
	--        },
	--        lazy = true
	--    },
	-- }
	-- return {} if not a lazy.nvim plugins
end

return module_create(get_plugins(), setup, options, get_keys_bind())
