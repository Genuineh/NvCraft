local dashboard_opt = {
  header = [[
            ██╗███████╗██████╗ ██████╗ ██╗   ██╗  ✨
        ██║██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
       ██║█████╗  ██████╔╝██████╔╝ ╚████╔╝
 ██   ██║██╔══╝  ██╔══██╗██╔══██╗  ╚██╔╝
╚█████╔╝███████╗██║  ██║██║  ██║   ██║
 ╚════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
]],
  keys = {
    { action = ":FzfLua files", desc = " Find file", icon = " ", key = "ff" },
    { action = ":FzfLua files cwd=~/Work/ ", desc = " Find file in Work", icon = " ", key = "fiw" },
    { action = ":FzfLua files cwd=~/github/ ", desc = " Find file in github", icon = " ", key = "fig" },
    {
      action = function()
        local project = require("nvcraft.core.modules.project")
        project.pick_func()
      end,
      desc = " Projects",
      icon = " ",
      key = "p",
    },
    { action = ":ene | startinsert", desc = " New file", icon = " ", key = "n" },
    { action = ":FzfLua oldfiles", desc = " Recent files", icon = " ", key = "r" },
    { action = ":FzfLua live_grep", desc = " Find text", icon = " ", key = "g" },
    {
      action = ':lua require("persistence").load({ last = true })',
      desc = " Restore Session",
      icon = " ",
      key = "s",
    },
    { action = ":Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
    { action = ":qa", desc = " Quit", icon = " ", key = "q" },
  },
}

return {
  name = "snacks",
  version = "1.0.0",
  description = "UI enhancements for Neovim.",
  category = "ui",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "snacks", "ui" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        dashboard = { enabled = true, preset = dashboard_opt },
      },
    },
  },
}
