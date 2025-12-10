return {
  name = "edgy",
  version = "1.0.0",
  description = "A window layout manager for Neovim.",
  category = "ui",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "edgy", "ui" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "folke/edgy.nvim",
      event = "VeryLazy",
      opts = {},
    },
  },
}
