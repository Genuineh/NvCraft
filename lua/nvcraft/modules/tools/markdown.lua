return {
  name = "markdown",
  version = "1.0.0",
  description = "Markdown preview.",
  category = "tools",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "markdown", "preview" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = function()
        vim.fn["mkdp#util#install"]()
      end,
      config = function()
        vim.cmd([[do FileType]])
      end,
    },
  },
  keys = {
    {
      "<leader>mp",
      ft = "markdown",
      "<cmd>MarkdownPreviewToggle<cr>",
      desc = "Markdown Preview",
    },
  },
}
