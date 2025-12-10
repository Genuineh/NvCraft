return {
  name = "comment",
  version = "1.0.0",
  description = "Treesitter-aware commenting.",
  category = "editor",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "comment", "treesitter" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "folke/ts-comments.nvim",
      event = "VeryLazy",
      opts = {},
    },
  },
}
