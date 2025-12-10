return {
  name = "illuminate",
  version = "1.0.0",
  description = "Highlighting for symbols under the cursor.",
  category = "editor",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "highlight", "illuminate" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "RRethy/vim-illuminate",
      event = "LazyFile",
      opts = {
        delay = 200,
        large_file_cutoff = 2000,
        large_file_overrides = {
          providers = { "lsp", "tressitter", "regex" },
        },
      },
      config = function(_, opts)
        require("illuminate").configure(opts)
      end,
    },
  },
}
