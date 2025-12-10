return {
  name = "lazygit",
  version = "1.0.0",
  description = "A UI for git.",
  category = "git",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "lazygit", "git" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "kdheepak/lazygit.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      opts = function()
        vim.g.lazygit_floating_window_winblend = 0
        vim.g.lazygit_floating_window_scaling_factor = 0.9
        vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
        vim.g.lazygit_floating_window_use_plenary = 0
        vim.g.lazygit_use_neovim_remote = 1
        vim.g.lazygit_use_custom_config_file_path = 0
        vim.g.lazygit_config_file_path = ""
      end,
      config = function() end,
      lazy = true,
      cmd = "LazyGit",
    },
  },
  keys = {
    { "<leader>gg", ":LazyGit<CR>", desc = "LazyGit" },
  },
}
