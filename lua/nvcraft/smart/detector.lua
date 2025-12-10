local M = {}

--- Detects the project type based on common markers.
-- @return table A list of detected project types (e.g., {"git", "node"}).
function M.detect_project_type()
  local types = {}
  local cwd = vim.fn.getcwd()

  -- Check for Git repository
  if vim.fn.isdirectory(cwd .. "/.git") == 1 then
    table.insert(types, "git")
  end

  -- Check for Node.js project
  if vim.fn.filereadable(cwd .. "/package.json") == 1 then
    table.insert(types, "node")
  end

  -- Check for Rust project
  if vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
    table.insert(types, "rust")
  end

  -- Check for Python project
  if vim.fn.filereadable(cwd .. "/requirements.txt") == 1 or vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
    table.insert(types, "python")
  end

  -- Check for Go project
  if vim.fn.filereadable(cwd .. "/go.mod") == 1 then
    table.insert(types, "go")
  end

  return types
end


--- Detects programming languages in the project by scanning file extensions.
-- @return table A sorted list of detected languages.
function M.detect_languages()
  local languages = {}
  local extension_map = {
    lua = "Lua",
    js = "JavaScript",
    ts = "TypeScript",
    py = "Python",
    go = "Go",
    rs = "Rust",
    java = "Java",
    c = "C",
    cpp = "C++",
    h = "C/C++ Header",
    cs = "C#",
    rb = "Ruby",
    php = "PHP",
    html = "HTML",
    css = "CSS",
    md = "Markdown",
    json = "JSON",
    yml = "YAML",
    yaml = "YAML",
    toml = "TOML",
    sh = "Shell",
  }

  local file_counts = {}
  local total_files = 0

  -- Using vim.fn.glob to find files recursively. This avoids a dependency on plenary for now.
  -- This might be slow on very large projects.
  -- We ignore files in .git directory
  local files = vim.fn.glob(vim.fn.getcwd() .. "/**", true, true)
  local file_list = {}
  for s in files:gmatch("[^\n]+") do
      if not s:match("/.git/") then
          table.insert(file_list, s)
      end
  end


  for _, file_path in ipairs(file_list) do
    local extension = file_path:match(".+%.([^%.]+)$")
    if extension then
      local lang = extension_map[extension]
      if lang then
        file_counts[lang] = (file_counts[lang] or 0) + 1
        total_files = total_files + 1
      end
    end
  end

  if total_files == 0 then
    return {}
  end

  -- Sort languages by file count
  local sorted_langs = {}
  for lang, _ in pairs(file_counts) do
    table.insert(sorted_langs, lang)
  end

  table.sort(sorted_langs, function(a, b)
    return file_counts[a] > file_counts[b]
  end)

  return sorted_langs
end

return M
