return {
  name = "formatter",
  version = "1.0.0",
  description = "Code formatting using conform.nvim.",
  category = "lsp",
  dependencies = { "mason" },
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "formatter", "conform" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
    },
  },
  setup = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        rust = { "rustfmt", lsp_format = "fallback" },
        go = { "goimports" },
        javascript = { "biome", stop_after_first = true },
        typescript = { "biome", stop_after_first = true },
        json = { "biome" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      callback = function(args)
        require("conform").format({ bufnr = args.buf })
      end,
    })
  end,
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
}
