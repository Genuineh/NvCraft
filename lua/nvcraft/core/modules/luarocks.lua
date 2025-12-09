return {
  name = "luarocks",
  version = "1.0.0",
  plugins = {
    {
      "vhyrro/luarocks.nvim",
      opts = {
        rocks = { "lyaml" },
      },
    },
  },
}
