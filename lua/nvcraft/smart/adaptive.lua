local M = {}

local context_provider = require("nvcraft.smart.context")
local config_manager = require("nvcraft.config.manager")

-- A store for original settings so we can restore them
local original_settings = {}

--- Adapts theme based on the time of day.
local function adapt_theme()
  local hour = tonumber(os.date("%H"))
  if hour >= 20 or hour < 6 then -- 8 PM to 6 AM
    if vim.o.background ~= "dark" then
      vim.o.background = "dark"
      vim.notify("Good evening! Switched to dark mode.", vim.log.levels.INFO)
    end
  else
    if vim.o.background ~= "light" then
      vim.o.background = "light"
      vim.notify("Good day! Switched to light mode.", vim.log.levels.INFO)
    end
  end
end


--- Adapts LSP server configurations based on detected toolchain.
local function adapt_lsp(context)
  -- This is a placeholder for a more complex implementation.
  -- A real implementation would interact with the lsp.servers module config.
  local toolchain = require("nvcraft.smart.detector").detect_toolchain()
  local tool_set = {}
  for _, tool in ipairs(toolchain) do
    tool_set[tool] = true
  end

  if context.filetype == "typescript" and not tool_set["tsc"] then
    vim.notify(
      "TypeScript file opened, but 'tsc' (TypeScript compiler) not found in your PATH.",
      vim.log.levels.WARN
    )
  end
end


--- Adapts Neovim's behavior based on the current context.
function M.adapt_to_context()
  local context = context_provider.get_context()

  -- 1. Adapt theme based on time
  adapt_theme()

  -- 2. Adapt LSP based on toolchain
  adapt_lsp(context)

  -- 3. Disable features in very large projects
  local files_in_project = #(vim.fn.glob(context.project.path .. "/**", true, true):split("\n"))
  if files_in_project > 5000 then -- Threshold for a "large" project
    local illuminate_config = config_manager.get_config("editor.illuminate")
    if illuminate_config and illuminate_config.enabled ~= false then
      original_settings["editor.illuminate"] = illuminate_config
      config_manager.set_config("editor.illuminate", { enabled = false })
      vim.notify("Large project detected. Disabling 'illuminate' for better performance.", vim.log.levels.INFO)
    end
  else
    if original_settings["editor.illuminate"] then
      config_manager.set_config("editor.illuminate", original_settings["editor.illuminate"])
      original_settings["editor.illuminate"] = nil
      vim.notify("Project size is normal. Restoring 'illuminate' settings.", vim.log.levels.INFO)
    end
  end

  -- 4. Adjust settings based on filetype
  if context.filetype == "markdown" then
    vim.opt_local.wrap = true
    vim.opt_local.textwidth = 80
  end
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
