return {
  name = "luarocks",
  version = "1.0.0",
  description = "Manages LuaRocks dependencies.",
  category = "base",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "luarocks", "dependencies" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "vhyrro/luarocks.nvim",
      opts = {
        rocks = { "lyaml" },
      },
    },
  },
}
