--- Utility functions for NvCraft
local M = {}

--- Performs a deep merge of two tables.
-- @param t1 (table) The base table.
-- @param t2 (table) The table to merge in.
-- @return (table) The merged table.
function M.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" and type(t1[k]) == "table" then
      t1[k] = M.deep_merge(t1[k], v)
    else
      t1[k] = v
    end
  end
  return t1
end

return M
