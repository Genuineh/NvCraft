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

--- Saves the current version of a file to a history directory.
-- @param file_path (string) The full path to the file to save.
local function save_to_history(file_path)
  if vim.fn.filereadable(file_path) ~= 1 then
    return
  end

  local dir = vim.fn.fnamemodify(file_path, ":h")
  local filename = vim.fn.fnamemodify(file_path, ":t")
  local history_dir = dir .. "/.history"
  vim.fn.mkdir(history_dir, "p")

  local timestamp = os.date("!%Y-%m-%dT%H-%M-%S")
  local history_path = string.format("%s/%s.%s", history_dir, timestamp, filename)

  vim.fn.copy(file_path, history_path)
end

--- Encodes a Lua table and writes it to a file.
-- @param file_path (string) The full path to the JSON or YAML file.
-- @param config (table) The Lua table to encode and write.
-- @return (boolean) True if writing was successful, false otherwise.
function M.write_config(file_path, config)
  -- Backup existing file before writing
  if vim.fn.filereadable(file_path) == 1 then
    backup_file(file_path)
    save_to_history(file_path .. ".bak") -- Save the backed-up version
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

local watched_files = {}

--- Watches a file for changes and triggers a callback.
-- @param file_path (string) The path to the file to watch.
-- @param callback (function) The function to call when the file changes.
function M.watch_file(file_path, callback)
  if not watched_files[file_path] then
    local poll_handle = vim.loop.new_fs_poll()
    if poll_handle then
      watched_files[file_path] = poll_handle
      poll_handle:start(file_path, 1000, function(err, stat)
        if err then
          -- File might have been deleted, stop watching
          poll_handle:stop()
          watched_files[file_path] = nil
        else
          callback(file_path)
        end
      end)
    else
      vim.notify("Could not create fs_poll handle for: " .. file_path, vim.log.levels.ERROR)
    end
  end
end

return M
