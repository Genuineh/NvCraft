-- lua/nvcraft/ui/dashboard.lua

local NuiPopup = require("nui.popup")
local NuiLine = require("nui.line")
local NuiText = require("nui.text")
local health = require("nvcraft.ui.health")
local module_manager = require("nvcraft.ui.module_manager")
local config_editor = require("nvcraft.ui.config_editor")

local M = {}

function M.setup()
  local popup = NuiPopup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = "NvCraft Dashboard",
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

  -- Health Summary
  local health_summary = health.get_health_summary()
  local health_status_icon = health_summary.status == "OK" and "✓" or "✗"
  local health_line = string.format("Health Status: %s %s", health_status_icon, health_summary.message)

  -- Quick Actions
  local quick_actions = {
    NuiText("Quick Actions"),
    NuiLine("  [m] Module Manager"),
    NuiLine("  [c] Config Editor"),
    NuiLine("  [h] Health Check"),
  }

  -- Content
  local lines = {
    NuiLine("Welcome to NvCraft!"),
    NuiLine(""),
    NuiLine(health_line),
    NuiLine(""),
  }

  for _, action in ipairs(quick_actions) do
    table.insert(lines, action)
  end

  table.insert(lines, NuiLine(""))
  table.insert(lines, NuiLine("Press 'q' to close."))

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

  popup:map("n", "h", function()
    popup:unmount()
    health.setup()
  end)

  popup:map("n", "m", function()
    popup:unmount()
    module_manager.setup()
  end)

  popup:map("n", "c", function()
    popup:unmount()
    config_editor.setup()
  end)
end

return M
