return {
  name = "smear_cursor",
  version = "1.0.0",
  description = "A smear effect for the cursor.",
  category = "ui",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "smear", "cursor", "ui" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "sphamba/smear-cursor.nvim",
      opts = {
        hide_target_hack = true,
        cursor_color = "none",
        stiffness = 0.8,
        trailing_stiffness = 0.5,
        distance_stop_animating = 0.5,
      },
    },
  },
}
