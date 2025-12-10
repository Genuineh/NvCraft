return {
  name = "images",
  version = "1.0.0",
  description = "Image support for Neovim.",
  category = "tools",
  dependencies = { "luarocks" },
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "images", "media" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "3rd/image.nvim",
      dependencies = {
        {
          "vhyrro/luarocks.nvim",
          priority = 1001,
          opts = {
            rocks = { "magick" },
          },
        },
      },
      enabled = true,
      opts = {
        {
          backend = "kitty",
          integrations = {},
          max_width = nil,
          max_height = nil,
          max_width_window_percentage = nil,
          max_height_window_percentage = 50,
          window_overlap_clear_enabled = true,
          window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
          editor_only_render_when_focused = true,
          tmux_show_only_in_active_window = true,
          hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
        },
      },
    },
  },
}
