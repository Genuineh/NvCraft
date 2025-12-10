return {
  name = "persistence",
  version = "1.0.0",
  description = "Session management for Neovim.",
  category = "files",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "persistence", "session" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      opts = { options = vim.opt.sessionoptions:get() },
    },
  },
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
  },
}
