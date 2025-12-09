local M = {
	root_bind_file_type = { ".sln" },
	root = "",
	modules = {},
}

M.modules_has = function(name)
	for _, module in ipairs(M.modules) do
		if module == name then
			return true
		end
	end
	return false
end

M.get_project_root = function(current_path)
	-- 在打开的文件中寻找根目录
	-- local current_path = vim.fn.expand("%:p:h")
	local files = vim.fn.readdir(current_path)
	for _, file in ipairs(files) do
		if file ~= "." and file ~= ".." then
			local full_path = current_path .. "/" .. file
			if vim.fn.isdirectory(full_path) then
				if file == ".git" then
					return current_path
				end
			else
				for i = 1, #M.root_bind_file_type do
					if file == M.root_bind_file_type[i] then
						return full_path
					end
				end
			end
		end
	end

	local git_dir = vim.fn.finddir(".git/.", ";")
	if git_dir == "" then
		return vim.fn.expand("%:p:h")
	end
	return vim.fn.fnamemodify(git_dir, ":h")
end

M.set_project_root = function(path)
	if path == "" or path == nil then
		return
	end

	if vim.fn.isdirectory(path) then
		path = vim.fn.fnamemodify(path, ":h")
	end
	-- local dir = path:match("(.+)[/\\][^/\\]+")
	-- if path ~= "" and path ~= nil and dir == nil then
	-- 	dir = ""
	-- end
	M.root = path
	print("project root:" .. M.root)
	vim.cmd("cd " .. M.root)
end

M.try_set_project_root = function(path)
	if M.root ~= "" then
		return
	end
	M.set_project_root(path)
end

local function find_git_root()
	-- 获取当前文件所在目录
	local current_dir = vim.fn.expand("%:p:h")
	local tmp_current_dir = current_dir

	-- 遍历父目录，直到找到包含 .git 的目录或到达根目录
	while current_dir ~= "/" do
		-- 检查当前目录是否包含 .git
		local git_dir = current_dir .. "/.git"
		if vim.fn.isdirectory(git_dir) == 1 then
			return current_dir
		end

		-- 向上移动到父目录
		current_dir = vim.fn.fnamemodify(current_dir, ":h")
	end

	-- 如果没有找到 .git 目录，以当前文件所在目录作为项目根目录
	return tmp_current_dir
end

M.setup = function(modules)
	M.modules = modules
	local args = vim.api.nvim_get_vvar("argv")
	if #args > 2 then
		-- print("args[3]:" .. vim.fn.expand("%:p:h"))
		M.try_set_project_root(find_git_root())
	end
end

return M
