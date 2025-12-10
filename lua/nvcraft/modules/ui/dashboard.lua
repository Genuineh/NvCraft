return {
  name = "dashboard",
  version = "1.0.0",
  description = "A dashboard for Neovim.",
  category = "ui",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "dashboard", "ui" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      opts = function()
        local logo = [[
            ██╗███████╗██████╗ ██████╗ ██╗   ██╗  ✨
        ██║██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
       ██║█████╗  ██████╔╝██████╔╝ ╚████╔╝
 ██   ██║██╔══╝  ██╔══██╗██╔══██╗  ╚██╔╝
╚█████╔╝███████╗██║  ██║██║  ██║   ██║
 ╚════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
]]

        logo = string.rep("\n", 8) .. logo .. "\n\n"

        local opts = {
          theme = "doom",
          hide = {
            statusline = false,
          },
          config = {
            header = vim.split(logo, "\n"),
            center = {
              { action = "FzfLua files", desc = " Find file", icon = " ", key = "ff" },
              { action = "FzfLua files cwd=~/Work/ ", desc = " Find file in Work", icon = " ", key = "fiw" },
              { action = "FzfLua files cwd=~/github/ ", desc = " Find file in github", icon = " ", key = "fig" },
              { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
              { action = "FzfLua oldfiles", desc = " Recent files", icon = " ", key = "r" },
              { action = "FzfLua live_grep", desc = " Find text", icon = " ", key = "g" },
              { action = 'lua require("persistence").load({ last = true })', desc = " Restore Session", icon = " ", key = "s" },
              { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
              { action = "qa", desc = " Quit", icon = " ", key = "q" },
            },
            footer = function()
              local stats = require("lazy").stats()
              local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
              return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
            end,
          },
        }

        for _, button in ipairs(opts.config.center) do
          button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
          button.key_format = "  %s"
        end

        if vim.o.filetype == "lazy" then
          vim.cmd.close()
          vim.api.nvim_create_autocmd("User", {
            pattern = "DashboardLoaded",
            callback = function()
              require("lazy").show()
            end,
          })
        end

        return opts
      end,
    },
  },
  keys = {
    {
      "<leader>hdb",
      "<Cmd>Dashboard<CR>",
      desc = "Open Dashboard",
    },
  },
}
