return {
  name = "obsidian",
  version = "1.0.0",
  description = "Obsidian support for Neovim.",
  category = "specialized",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "obsidian", "notes" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "obsidian-nvim/obsidian.nvim",
      version = "*",
      opts = {
        legacy_commands = false,
        workspaces = {
          {
            name = "work",
            path = "~/valuts/work",
          },
          {
            name = "doc",
            path = "~/valuts/doc",
          },
        },
      },
    },
  },
}
