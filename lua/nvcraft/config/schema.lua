--- Configuration schema for NvCraft.
local M = {}

--- The main configuration schema.
M.schema = {
  type = "table",
  properties = {
    theme = { type = "string" },
    ui = {
      type = "table",
      properties = {
        font_size = { type = "number" },
      },
    },
    completion = {
      type = "table",
      properties = {
        enable = { type = "boolean" },
        backend = { type = "string" },
      },
    },
    git = {
      type = "table",
      properties = {
        enable = { type = "boolean" },
        signs = {
          type = "table",
          properties = {
            enable = { type = "boolean" },
          },
        },
      },
    },
    formatter = {
      type = "table",
      properties = {
        enable = { type = "boolean" },
        auto_format_on_save = { type = "boolean" },
      },
    },
    version = { type = "number" },
  },
}

return M
