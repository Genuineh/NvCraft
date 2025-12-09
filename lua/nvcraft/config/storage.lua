-- Basic JSON storage implementation for configuration
local M = {}

--- Reads and decodes a JSON config file.
-- @param file_path (string) The full path to the JSON file.
-- @return (table|nil) The decoded Lua table, or nil if an error occurs.
function M.read_config(file_path)
	local content = ""
	local file = io.open(file_path, "r")

	if file then
		content = file:read("*a")
		file:close()
	else
		return nil -- File doesn't exist or is not readable
	end

	if content == "" then
		return {} -- Return empty table for empty file
	end

	local ok, decoded = pcall(vim.fn.json_decode, content)
	if ok then
		return decoded
	else
		vim.notify("Error decoding JSON from " .. file_path .. ":\n" .. decoded, vim.log.levels.ERROR)
		return nil
	end
end

--- Encodes a Lua table and writes it to a JSON file.
-- @param file_path (string) The full path to the JSON file.
-- @param config (table) The Lua table to encode and write.
-- @return (boolean) True if writing was successful, false otherwise.
function M.write_config(file_path, config)
	local ok, encoded = pcall(vim.fn.json_encode, config)
	if not ok then
		vim.notify("Error encoding config to JSON: " .. encoded, vim.log.levels.ERROR)
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
