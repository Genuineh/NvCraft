return {
  name = "autopairs",
  version = "1.0.0",
  description = "Autopairs for Neovim.",
  category = "editor",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "autopairs" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("nvim-autopairs").setup()
      end,
    },
  },
}
