local M = {}

local context_provider = require("nvcraft.smart.context")
local config_manager = require("nvcraft.config.manager")

-- A store for original settings so we can restore them
local original_settings = {}

--- Adapts Neovim's behavior based on the current context.
function M.adapt_to_context()
  local context = context_provider.get_context()

  -- Example 1: Disable certain features in very large projects to improve performance
  -- For this, we need a way to estimate project size. Let's count files.
  local files_in_project = #(vim.fn.glob(context.project.path .. "/**", true, true):split("\n"))

  if files_in_project > 5000 then -- Threshold for a "large" project
    -- Disable something that might be slow, e.g., git signs or certain LSP features
    -- For demonstration, let's disable illuminate module if it exists
    local illuminate_config = config_manager.get_config("editor.illuminate")
    if illuminate_config then
      original_settings["editor.illuminate"] = illuminate_config
      config_manager.set_config("editor.illuminate", { enabled = false })
      vim.notify("Large project detected. Disabling 'illuminate' for better performance.", vim.log.levels.INFO)
    end
  else
    -- If project is not large, ensure settings are restored to their original state
    if original_settings["editor.illuminate"] then
      config_manager.set_config("editor.illuminate", original_settings["editor.illuminate"])
      original_settings["editor.illuminate"] = nil -- Clear the stored setting
      vim.notify("Project size is normal. Restoring 'illuminate' settings.", vim.log.levels.INFO)
    end
  end


  -- Example 2: Adjust settings based on filetype
  if context.filetype == "markdown" then
    -- For markdown, we might want different text wrapping settings
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 80
  end

  -- We need a mechanism to trigger this adaptation.
  -- This can be done via autocmds on events like BufEnter, DirChanged, etc.
end

--- Sets up autocmds to trigger adaptive changes.
function M.setup_autocmds()
  local group = vim.api.nvim_create_augroup("NvCraftAdaptive", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
    group = group,
    pattern = "*",
    callback = function()
      vim.schedule(M.adapt_to_context) -- Use vim.schedule to run it asynchronously
    end,
  })
end


-- Call setup_autocmds when the module is loaded
M.setup_autocmds()

return M
