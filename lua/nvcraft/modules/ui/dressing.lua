return {
  name = "dressing",
  version = "1.0.0",
  description = "UI wrapper for `vim.ui.select` and `vim.ui.input`.",
  category = "ui",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "dressing", "ui" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "stevearc/dressing.nvim",
      lazy = true,
      init = function()
        vim.ui.select = function(...)
          require("lazy").load({ plugins = { "dressing.nvim" } })
          return vim.ui.select(...)
        end
        vim.ui.input = function(...)
          require("lazy").load({ plugins = { "dressing.nvim" } })
          return vim.ui.input(...)
        end
      end,
    },
  },
}
