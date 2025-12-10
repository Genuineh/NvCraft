-- lua/nvcraft/config/templates.lua

local M = {}

M.templates = {
  editor = {
    completion = {
      enabled = true,
      provider = "nvim-cmp",
    },
    snippets = {
      enabled = true,
      provider = "luasnip",
    },
  },
  lsp = {
    servers = {
      enabled = true,
      servers = { "lua_ls", "bashls", "jsonls" },
    },
    formatter = {
      enabled = true,
      format_on_save = true,
    },
  },
}

return M
