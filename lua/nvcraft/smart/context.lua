local M = {}

local detector = require("nvcraft.smart.detector")

--- Gathers information about the current context.
-- @return table A table containing context information.
function M.get_context()
  local context = {}
  local cwd = vim.fn.getcwd()

  -- File context
  local current_buf = vim.api.nvim_get_current_buf()
  context.filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")
  context.filename = vim.api.nvim_buf_get_name(current_buf)
  context.is_modified = vim.api.nvim_buf_get_option(current_buf, "modified")

  -- Project context
  context.project = {
    path = cwd,
    name = vim.fn.fnamemodify(cwd, ":t"),
    types = detector.detect_project_type(),
    languages = detector.detect_languages(),
  }

  -- Git context
  if vim.fn.isdirectory(cwd .. "/.git") == 1 then
    local git_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    if vim.v.shell_error == 0 then
      context.git = {
        branch = vim.fn.trim(git_branch),
        -- More git info could be added here (e.g., status, upstream)
      }
    else
      context.git = { branch = "unknown" }
    end
  end

  -- Workspace context (e.g., LSP servers, open buffers)
  local active_clients = vim.lsp.get_active_clients({ bufnr = current_buf })
  local server_names = {}
  for _, client in ipairs(active_clients) do
    table.insert(server_names, client.name)
  end
  context.workspace = {
    active_lsp_servers = server_names,
    open_buffers = #vim.api.nvim_list_bufs(),
  }

  return context
end

return M
