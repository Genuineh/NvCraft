local get_go_test_args = function()
	local default = { "-v", "-race", "-count=1", "-tags=integration" }
	local custom_args = {}
	local file_path = vim.loop.cwd() .. "/.go_test_args.json"
	-- print(file_path)
	if vim.fn.filereadable(file_path) == 1 then
		local file = io.open(file_path, "r")
		if file then
			local content = file:read("*a")
			file:close()
			local ok, json = pcall(vim.fn.json_decode, content)
			if ok and type(json) == "table" then
				custom_args = json
			end
		end
	end
	for k, v in pairs(custom_args) do
		table.insert(default, v)
	end
	return default
end

local setup = function()
	--like
	local adapters = {
		-- require("neotest-dotnet")({
		-- 	dap = { justMyCode = true },
		-- 	-- adapter_name = "coreclr",
		-- 	discovery_root = "solution", -- Default
		-- }),
		require("neotest-vstest"),
		require("neotest-dart")({
			command = "fvm flutter",
			use_lsp = true,
			custom_test_method_names = {},
			dap = { justMyCode = true },
		}),
		require("neotest-golang")({
			go_test_args = get_go_test_args,
		}),
		-- require("neotest-python")({
		--     dap = { justMyCode = false },
		-- }),
		-- require("neotest-ctest").setup({}),
		require("neotest-gtest").setup({}),
		require("neotest-plenary"),
	}
	require("neotest").setup({
		adapters = adapters,
		status = { virtual_text = true },
		output = { open_on_run = true },
		log_level = vim.log.levels.OFF,
	})
end

local function get_all_test()
	local test = {}
	local files = vim.fn.globpath(vim.loop.cwd(), "**/*", true, true)
	for _, file in ipairs(files) do
		if vim.fn.filereadable(file) == 1 then
			local ext = vim.fn.fnamemodify(file, ":e")
			if ext == "cs" or ext == "py" or ext == "lua" or ext == "vim" then
				table.insert(test, file)
			end
		end
	end
	return test
end

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-neotest/nvim-nio",
		"nvim-neotest/neotest-plenary",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nsidorenco/neotest-vstest",
		-- "Issafalcon/neotest-dotnet",
		"sidlatau/neotest-dart",
		"alfaix/neotest-gtest",
		"fredrikaverpil/neotest-golang",
		-- "orjangj/neotest-ctest",
	},
	config = setup,
	keys = {
		{
			mode = { "n" },
			"<leader>tt",
			"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
			desc = "run test in currentt file",
		},
		{
			mode = { "n" },
			"<leader>tr",
			"<cmd>lua require('neotest').run.run()<cr>",
			desc = "run near test",
		},
		{
			mode = { "n" },
			"<leader>tw",
			"<cmd>lua require('neotest').summary.toggle()<cr>",
			desc = "open test summary",
		},
		{
			mode = { "n" },
			"<leader>tS",
			"<cmd>lua require('neotest').run.stop()<cr>",
			desc = "test stop",
		},
		{
			mode = { "n" },
			"<leader>tO",
			"<cmd>lua require('neotest').output_panel.toggle()<cr>",
			desc = "test stop",
		},
		{
			mode = { "n" },
			"<leader>to",
			"<cmd>lua require('neotest').output_open(enter = true, auto_close = true)<cr>",
			desc = "open ouput",
		},
		{
			"<leader>tT",
			function()
				local tests = get_all_test()
				for i = 1, #tests, 1 do
					require("neotest").run.run(tests[i])
				end
			end,
			"Run all tests in project",
		},
	},
}
