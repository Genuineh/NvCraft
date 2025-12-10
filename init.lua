vim.g.nvcraft_start_time = vim.v.t_start

local COREPATH = "nvcraft.core"
local core = require(COREPATH .. ".init")
core.Load(COREPATH)

vim.api.nvim_create_user_command("NvCraftModuleManager", function()
  require("nvcraft.ui.module_manager").setup()
end, {})

vim.api.nvim_create_user_command("NvCraftConfigEditor", function()
  require("nvcraft.ui.config_editor").setup()
end, {})

vim.api.nvim_create_user_command("NvCraftDashboard", function()
  require("nvcraft.ui.dashboard").setup()
end, {})

vim.api.nvim_create_user_command("NvCraftHealth", function()
  require("nvcraft.ui.health").setup()
end, {})

-- First time setup wizard
vim.defer_fn(function()
  local config_manager = require("nvcraft.config.manager")
  local core_config = config_manager.get_config("nvcraft.core")
  if not core_config or not core_config.wizard_completed then
    require("nvcraft.ui.wizard").setup()
  end
end, 100)
