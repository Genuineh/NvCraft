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
