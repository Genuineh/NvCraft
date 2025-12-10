return {
  name = "aerial",
  version = "1.0.0",
  description = "A code outline window.",
  category = "tools",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "aerial", "outline" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "stevearc/aerial.nvim",
      event = "LazyFile",
      opts = function()
        local opts = {
          attach_mode = "global",
          backends = { "lsp", "treesitter", "markdown", "man" },
          show_guides = true,
          layout = {
            resize_to_content = false,
            win_opts = {
              winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
              signcolumn = "yes",
              statuscolumn = " ",
            },
          },
          guides = {
            mid_item = "├╴",
            last_item = "└╴",
            nested_top = "│ ",
            whitespace = "  ",
          },
        }
        return opts
      end,
    },
  },
  keys = {
    { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
  },
}
