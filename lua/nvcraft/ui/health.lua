-- lua/nvcraft/ui/health.lua

local NuiPopup = require("nui.popup")
local NuiLine = require("nui.line")
local registry = require("nvcraft.core.registry")

local M = {}

local function check_neovim_version()
  local version = vim.version()
  local required_version = { major = 0, minor = 9, patch = 0 }

  if version.major > required_version.major or
     (version.major == required_version.major and version.minor >= required_version.minor) then
    return {
      name = "Neovim Version",
      status = "OK",
      message = string.format("v%d.%d.%d", version.major, version.minor, version.patch),
    }
  else
    return {
      name = "Neovim Version",
      status = "ERROR",
      message = string.format("v%d.%d.%d (required: >= v%d.%d.%d)",
        version.major, version.minor, version.patch,
        required_version.major, required_version.minor, required_version.patch),
    }
  end
end

local function run_module_health_checks()
  local results = {}
  local modules = registry.get_modules()

  for _, module_name in ipairs(modules) do
    local spec = registry.get_module_spec(module_name)
    if spec and spec.health_check and type(spec.health_check) == "function" then
      local ok, result = pcall(spec.health_check)
      if ok then
        table.insert(results, result)
      else
        table.insert(results, {
          name = module_name,
          status = "ERROR",
          message = "Health check function failed to execute: " .. tostring(result),
        })
      end
    end
  end
  return results
end

local function run_health_checks()
  local results = {}
  table.insert(results, check_neovim_version())

  local module_results = run_module_health_checks()
  for _, result in ipairs(module_results) do
    table.insert(results, result)
  end

  return results
end

function M.setup()
  local results = run_health_checks()

  local popup = NuiPopup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = "Health Check",
        top_align = "center",
      },
    },
    position = "50%",
    size = {
      width = "80%",
      height = "80%",
    },
  })

  popup:mount()

  local lines = {}
  for _, result in ipairs(results) do
    local status_icon = result.status == "OK" and "✓" or "✗"
    table.insert(lines, NuiLine(string.format("%s [%s] %s: %s", status_icon, result.status, result.name, result.message)))
  end
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)

  popup:on({
    event = "BufLeave",
    callback = function()
      popup:unmount()
    end,
  })

  popup:map("n", "q", function()
    popup:unmount()
  end)
end

function M.get_health_summary()
  local results = run_health_checks()
  local errors = 0
  for _, result in ipairs(results) do
    if result.status ~= "OK" then
      errors = errors + 1
    end
  end

  if errors > 0 then
    return { status = "ERROR", message = string.format("%d health check(s) failed", errors) }
  else
    return { status = "OK", message = "All health checks passed" }
  end
end

return M
