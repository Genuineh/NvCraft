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
  themes = {
    { name = "kanagawa-wave", plugin = "rebelot/kanagawa.nvim" },
    { name = "tokyonight", plugin = "folke/tokyonight.nvim" },
    { name = "catppuccin", plugin = "catppuccin/nvim" },
    { name = "everforest", plugin = "neanias/everforest-nvim" },
  },
  keymap_profiles = {
    {
      name = "NvCraft Defaults",
      id = "nvcraft",
      description = "Default keymaps for NvCraft, optimized for efficiency.",
    },
    {
      name = "VSCode Legacy",
      id = "vscode",
      description = "Keymaps similar to Visual Studio Code.",
    },
    {
      name = "JetBrains Legacy",
      id = "jetbrains",
      description = "Keymaps similar to JetBrains IDEs.",
    },
  },
  module_profiles = {
    {
      id = "general",
      name = "General",
      description = "A balanced set of modules for general-purpose development.",
      modules = { "base", "editor", "ui", "files", "git", "tools" },
    },
    {
      id = "web",
      name = "Web Development",
      description = "Modules tailored for modern web development (JS/TS, HTML, CSS).",
      modules = { "base", "editor", "lsp", "ui", "files", "git", "tools", "ai" },
    },
    {
      id = "systems",
      name = "Systems Programming",
      description = "A lean setup for low-level development (C/C++, Rust).",
      modules = { "base", "editor", "lsp", "git", "tools" },
    },
  },
}

return M
