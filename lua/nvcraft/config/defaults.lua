--- Default configuration for NvCraft modules.
-- @return (table) The default configuration table.
return function()
  return {
    -- Example default settings
    core = {
      editor = {
        theme = "catppuccin",
      },
    },
    -- Modules can add their default configs here
    plugin_a = {
      enabled = true,
      setting_1 = "default_value",
    },
  }
end
