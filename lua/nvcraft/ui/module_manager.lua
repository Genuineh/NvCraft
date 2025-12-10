-- lua/nvcraft/ui/module_manager.lua

local NuiPopup = require("nui.popup")
local NuiLine = require("nui.line")
local registry = require("nvcraft.core.registry")
local config_manager = require("nvcraft.config.manager")

local M = {}

local function get_module_display(module_name)
  local config = config_manager.get_config(module_name)
  local is_enabled = config and config.enabled
  local status = is_enabled and "[x]" or "[ ]"
  return NuiLine(string.format("%s %s", status, module_name))
end

local function open_config_editor(module_name)
  local config = config_manager.get_config(module_name) or {}
  -- Use JSON for safe serialization and deserialization.
  local config_string = vim.fn.json_encode(config)

  local editor_popup = NuiPopup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = "Edit Config (JSON): " .. module_name,
        top_align = "center",
      },
    },
    position = "50%",
    size = {
      width = "80%",
      height = "80%",
    },
  })

  editor_popup:mount()
  vim.api.nvim_buf_set_option(editor_popup.bufnr, "filetype", "json")
  vim.api.nvim_buf_set_lines(editor_popup.bufnr, 0, -1, false, vim.split(config_string, "\n"))

  editor_popup:on({
    event = "BufLeave",
    callback = function()
      editor_popup:unmount()
    end,
  })

  editor_popup:map("n", "q", function()
    editor_popup:unmount()
  end)

  editor_popup:map("n", "<leader>w", function()
    local lines = vim.api.nvim_buf_get_lines(editor_popup.bufnr, 0, -1, false)
    local new_config_string = table.concat(lines, "")
    local ok, new_config = pcall(vim.fn.json_decode, new_config_string)

    if ok then
      config_manager.set_config(module_name, new_config)
      editor_popup:unmount()
    else
      vim.notify("Invalid JSON format: " .. tostring(new_config), vim.log.levels.ERROR)
    end
  end)
end

local function show_dependencies(module_name)
  local spec = registry.get_module_spec(module_name)
  if not spec or not spec.dependencies or #spec.dependencies == 0 then
    vim.notify("Module has no dependencies.", vim.log.levels.INFO)
    return
  end

  local dep_lines = {}
  for _, dep in ipairs(spec.dependencies) do
    table.insert(dep_lines, NuiLine(dep))
  end

  local deps_popup = NuiPopup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = "Dependencies: " .. module_name,
        top_align = "center",
      },
    },
    position = "50%",
    size = {
      width = "60%",
      height = "40%",
    },
  })

  deps_popup:mount()
  vim.api.nvim_buf_set_lines(deps_popup.bufnr, 0, -1, false, dep_lines)

  deps_popup:on({
    event = "BufLeave",
    callback = function()
      deps_popup:unmount()
    end,
  })

  deps_popup:map("n", "q", function()
    deps_popup:unmount()
  end)
end

function M.setup()
  local modules = registry.get_modules()
  local filtered_modules = modules

  local popup = NuiPopup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = "Modules",
        top_align = "center",
      },
    },
    position = "50%",
    size = {
      width = "80%",
      height = "80%",
    },
  })

  local function update_lines()
    local new_lines = {}
    for _, module_name in ipairs(filtered_modules) do
      table.insert(new_lines, get_module_display(module_name))
    end
    local cursor = vim.api.nvim_win_get_cursor(popup.winid)
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, new_lines)
    vim.api.nvim_win_set_cursor(popup.winid, cursor)
  end

  popup:mount()
  update_lines()

  popup:on({
    event = "BufLeave",
    callback = function()
      popup:unmount()
    end,
  })

  popup:map("n", "q", function()
    popup:unmount()
  end)

  popup:map("n", "<CR>", function()
    local line_number = vim.api.nvim_win_get_cursor(popup.winid)[1]
    local module_name = filtered_modules[line_number]
    if module_name then
      local config = config_manager.get_config(module_name) or {}
      config.enabled = not config.enabled
      config_manager.set_config(module_name, config)
      update_lines()
    end
  end)

  popup:map("n", "e", function()
    local line_number = vim.api.nvim_win_get_cursor(popup.winid)[1]
    local module_name = filtered_modules[line_number]
    if module_name then
      open_config_editor(module_name)
    end
  end)

  popup:map("n", "/", function()
    vim.ui.input({ prompt = "Search:" }, function(input)
      if input and input ~= "" then
        filtered_modules = {}
        for _, module_name in ipairs(modules) do
          if module_name:find(input, 1, true) then
            table.insert(filtered_modules, module_name)
          end
        end
      else
        filtered_modules = modules
      end
      update_lines()
    end)
  end)

  popup:map("n", "d", function()
    local line_number = vim.api.nvim_win_get_cursor(popup.winid)[1]
    local module_name = filtered_modules[line_number]
    if module_name then
      show_dependencies(module_name)
    end
  end)
end

return M
