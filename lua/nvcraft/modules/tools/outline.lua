return {
  name = "outline",
  version = "1.0.0",
  description = "Code outline.",
  category = "tools",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "outline", "code" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "hedyhli/outline.nvim",
      lazy = true,
      cmd = { "Outline", "OutlineOpen" },
      opts = {
        outline_window = {
          winhl = "",
        },
      },
    },
  },
  keys = {
    { "<leader>;", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
}
