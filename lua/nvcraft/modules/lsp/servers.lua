return {
  name = "lsp_servers",
  version = "1.0.0",
  description = "LSP server configurations.",
  category = "lsp",
  dependencies = { "mason" },
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "lsp", "servers" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "p00f/clangd_extensions.nvim",
      lazy = true,
      config = function() end,
      opts = {
        inlay_hints = {
          inline = false,
        },
        ast = {
          --These require codicons (https://github.com/microsoft/vscode-codicons)
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },
          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },
        },
      },
    },
  },
}
