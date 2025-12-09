--- Configuration storage with support for JSON and YAML, including automatic backups.
local M = {}

local lyaml = require("lyaml")

--- Backs up a file by renaming it with a .bak extension.
-- @param file_path (string) The full path to the file to back up.
local function backup_file(file_path)
  local backup_path = file_path .. ".bak"
  -- Remove existing backup file to prevent errors on some systems
  os.remove(backup_path)
  os.rename(file_path, backup_path)
end

--- Determines the file type from its extension.
-- @param file_path (string) The path to the file.
-- @return (string|nil) "json", "yaml", or nil if the type is unsupported.
local function get_file_type(file_path)
  if file_path:match("%.json$") then
    return "json"
  elseif file_path:match("%.yml$") or file_path:match("%.yaml$") then
    return "yaml"
  else
    return nil
  end
end

--- Reads and decodes a config file.
-- @param file_path (string) The full path to the JSON or YAML file.
-- @return (table|nil) The decoded Lua table, or nil if an error occurs.
function M.read_config(file_path)
  local file = io.open(file_path, "r")
  if not file then
    return nil -- File doesn't exist or is not readable
  end

  local content = file:read("*a")
  file:close()

  if content == "" then
    return {} -- Return empty table for empty file
  end

  local file_type = get_file_type(file_path)
  local ok, decoded

  if file_type == "json" then
    ok, decoded = pcall(vim.fn.json_decode, content)
  elseif file_type == "yaml" then
    ok, decoded = pcall(lyaml.load, content)
  else
    vim.notify("Unsupported config file format: " .. file_path, vim.log.levels.ERROR)
    return nil
  end

  if ok then
    return decoded
  else
    vim.notify("Error decoding " .. file_type:upper() .. " from " .. file_path .. ":\n" .. tostring(decoded), vim.log.levels.ERROR)
    return nil
  end
end

--- Encodes a Lua table and writes it to a file.
-- @param file_path (string) The full path to the JSON or YAML file.
-- @param config (table) The Lua table to encode and write.
-- @return (boolean) True if writing was successful, false otherwise.
function M.write_config(file_path, config)
  -- Backup existing file before writing
  if vim.fn.filereadable(file_path) == 1 then
    backup_file(file_path)
  end

  local file_type = get_file_type(file_path)
  local ok, encoded

  if file_type == "json" then
    ok, encoded = pcall(vim.fn.json_encode, config)
  elseif file_type == "yaml" then
    ok, encoded = pcall(lyaml.dump, config)
  else
    vim.notify("Unsupported config file format: " .. file_path, vim.log.levels.ERROR)
    return false
  end

  if not ok then
    vim.notify("Error encoding config to " .. file_type:upper() .. ": " .. tostring(encoded), vim.log.levels.ERROR)
    return false
  end

  local file = io.open(file_path, "w")
  if file then
    file:write(encoded)
    file:close()
    return true
  else
    vim.notify("Failed to open file for writing: " .. file_path, vim.log.levels.ERROR)
    return false
  end
end

return M
