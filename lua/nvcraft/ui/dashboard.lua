-- lua/nvcraft/ui/dashboard.lua

local NuiPopup = require("nui.popup")
local NuiLine = require("nui.line")
local NuiText = require("nui.text")
local health = require("nvcraft.ui.health")
local module_manager = require("nvcraft.ui.module_manager")
local config_editor = require("nvcraft.ui.config_editor")
local registry = require("nvcraft.core.registry")

local M = {}

local function get_startup_time()
  if vim.g.nvcraft_start_time then
    local end_time = vim.loop.hrtime()
    local elapsed_ms = (end_time - vim.g.nvcraft_start_time) / 1000000
    return string.format("%.2f ms", elapsed_ms)
  end
  return "N/A"
end

local logo = {
  [[ __  __   ____  __          __  _ ]],
  [[ \ \/ /  / __/ / /_  ____  / /_(_)___   ___  ]],
  [[  \  /  / /_  / __/ / __ \/ __// // _ \ / _ \ ]],
  [[  / /  / __/ / /_  / /_/ / /_ / //  __//  __/ ]],
  [[ /_/  /_/    \__/  \____/\__//_/ \___/ \___/  ]],
}

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

  -- Logo
  for i, line in ipairs(logo) do
    logo[i] = NuiText(line, "DashboardLogo")
  end

  -- Health Summary
  local health_summary = health.get_health_summary()
  local health_status_icon = health_summary.status == "OK" and "✓" or "✗"
  local health_line = string.format("Health Status: %s %s", health_status_icon, health_summary.message)

  -- Quick Actions
  local quick_actions = {
    NuiText("Quick Actions", "DashboardHeader"),
    NuiLine("  [m] Module Manager"),
    NuiLine("  [c] Config Editor"),
    NuiLine("  [h] Health Check"),
    NuiLine("  [s] Smart Recommend"),
    NuiLine("  [o] Optimize"),
  }

  -- Statistics
  local stats = {
    NuiText("Statistics", "DashboardHeader"),
    NuiLine(string.format("  Loaded Modules: %d", #registry.get_modules())),
    NuiLine(string.format("  Startup Time: %s", get_startup_time())),
  }

  -- Recent Projects
  local recent_projects_lines = { NuiText("Recent Projects", "DashboardHeader") }
  if vim.g.nvcraft_recent_projects and #vim.g.nvcraft_recent_projects > 0 then
    for i, project in ipairs(vim.g.nvcraft_recent_projects) do
      if i > 9 then break end
      table.insert(recent_projects_lines, NuiLine(string.format("  [%d] %s", i, project)))
    end
  else
    table.insert(recent_projects_lines, NuiLine("  No recent projects."))
  end

  -- Layout
  local lines = {}
  for _, line in ipairs(logo) do
    table.insert(lines, line)
  end
  table.insert(lines, NuiLine(""))
  table.insert(lines, NuiLine(health_line))
  table.insert(lines, NuiLine(""))

  for _, action in ipairs(quick_actions) do
    table.insert(lines, action)
  end
  table.insert(lines, NuiLine(""))

  for _, stat in ipairs(stats) do
    table.insert(lines, stat)
  end
  table.insert(lines, NuiLine(""))

  for _, project_line in ipairs(recent_projects_lines) do
    table.insert(lines, project_line)
  end
  table.insert(lines, NuiLine(""))

  table.insert(lines, NuiLine("Press 'q' to close."))

  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)
  vim.api.nvim_set_hl(0, "DashboardLogo", { fg = "#50a14f" }) -- Green
  vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#c678dd" }) -- Purple

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

  popup:map("n", "s", function()
    popup:unmount()
    vim.cmd("NvCraftSmartRecommend")
  end)

  popup:map("n", "o", function()
    popup:unmount()
    vim.cmd("NvCraftOptimize")
  end)

  -- Project switching keymaps
  if vim.g.nvcraft_recent_projects and #vim.g.nvcraft_recent_projects > 0 then
    for i = 1, math.min(#vim.g.nvcraft_recent_projects, 9) do
      popup:map("n", tostring(i), function()
        local project_path = vim.g.nvcraft_recent_projects[i]
        if project_path then
          popup:unmount()
          vim.cmd("cd " .. project_path)
          vim.notify("Switched to project: " .. project_path)
        end
      end)
    end
  end
end

return M
