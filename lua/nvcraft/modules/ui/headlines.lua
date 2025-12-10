return {
  name = "headlines",
  version = "1.0.0",
  description = "Headline highlighting for Markdown and Org-mode.",
  category = "ui",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "headlines", "ui", "markdown", "orgmode" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "lukas-reineke/headlines.nvim",
      opts = function()
        local opts = {}
        for _, ft in ipairs({ "markdown", "norg", "rmd", "org" }) do
          opts[ft] = {
            headline_highlights = {},
            bullets = {},
          }
          for i = 1, 6 do
            local hl = "Headline" .. i
            vim.api.nvim_set_hl(0, hl, { link = "Headline", default = true })
            table.insert(opts[ft].headline_highlights, hl)
          end
        end
        return opts
      end,
      ft = { "markdown", "norg", "rmd", "org" },
      config = function(_, opts)
        vim.schedule(function()
          require("headlines").setup(opts)
          require("headlines").refresh()
        end)
      end,
    },
  },
}
