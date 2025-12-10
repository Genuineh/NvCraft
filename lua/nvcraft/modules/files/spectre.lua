return {
  name = "spectre",
  version = "1.0.0",
  description = "Search and replace in files.",
  category = "files",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "spectre", "search", "replace" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "MagicDuck/grug-far.nvim",
      cmd = "GrugFar",
      opts = {
        headerMaxWidth = 80,
      },
    },
  },
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Replace in files (Grug)",
    },
  },
}
