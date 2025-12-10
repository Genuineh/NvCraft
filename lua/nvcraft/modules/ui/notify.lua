return {
  name = "notify",
  version = "1.0.0",
  description = "A notification manager for Neovim.",
  category = "ui",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "notify", "ui" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "rcarriga/nvim-notify",
      opts = {
        timeout = 1500,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end,
      },
      config = function(_, opts)
        local notify = require("notify")
        notify.setup(opts)
        vim.notify = notify
      end,
    },
  },
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss all Notifications",
    },
  },
}
