return {
  name = "lazydev",
  version = "1.S-Enter>",
  description = "Lazy.nvim development environment.",
  category = "tools",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "lazydev", "development" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "folke/lazydev.nvim",
      dependencies = {
        { "Bilal2453/luvit-meta", lazy = true },
      },
      ft = { "lua" },
      cmd = "LazyDev",
      opts = {
        library = {
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { path = "lazy.nvim", words = { "LazyVim" } },
        },
      },
    },
  },
}
