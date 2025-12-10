-- lua/nvcraft/ui/config_editor.lua

local NuiPopup = require("nui.popup")
local NuiLine = require("nui.line")
local config_manager = require("nvcraft.config.manager")
local registry = require("nvcraft.core.registry")
local templates = require("nvcraft.config.templates")

local M = {}

function M.setup()
  local folded_modules = {}
  local line_metadata = {}

  local function build_config_lines()
    local modules = registry.get_modules()
    local lines = {}
    line_metadata = {}
    local line_num = 1

    for _, module_name in ipairs(modules) do
      line_metadata[line_num] = { type = "module", name = module_name }
      if folded_modules[module_name] then
        table.insert(lines, NuiLine("+" .. module_name))
        line_num = line_num + 1
      else
        table.insert(lines, NuiLine("-" .. module_name))
        line_num = line_num + 1
        local config = config_manager.get_config(module_name)
        if config then
          for key, value in pairs(config) do
            line_metadata[line_num] = { type = "key", module = module_name, key = key }
            local value_str = tostring(value)
            table.insert(lines, NuiLine(string.format("  %s = %s", key, value_str)))
            line_num = line_num + 1
          end
        end
      end
    end

    return lines
  end

  local popup = NuiPopup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = "Config Editor",
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
    local new_lines = build_config_lines()
    local cursor = vim.api.nvim_win_get_cursor(popup.winid)
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, new_lines)
    vim.api.nvim_win_set_cursor(popup.winid, cursor)
  end

  popup:mount()
  update_lines()

  popup:map("n", "<CR>", function()
    local line_number = vim.api.nvim_win_get_cursor(popup.winid)[1]
    local meta = line_metadata[line_number]

    if not meta then
      return
    end

    if meta.type == "module" then
      folded_modules[meta.name] = not folded_modules[meta.name]
      update_lines()
    elseif meta.type == "key" then
      vim.ui.input({ prompt = "New value for " .. meta.key .. ":" }, function(input)
        if input then
          local ok, new_value = pcall(function()
            if tonumber(input) then
              return tonumber(input)
            elseif input == "true" then
              return true
            elseif input == "false" then
              return false
            else
              return input
            end
          end)

          if ok then
            local config = config_manager.get_config(meta.module) or {}
            config[meta.key] = new_value
            config_manager.set_config(meta.module, config)
            update_lines()
          else
            vim.notify("Invalid value provided.", vim.log.levels.ERROR)
          end
        end
      end)
    end
  end)

  popup:map("n", "t", function()
    local line_number = vim.api.nvim_win_get_cursor(popup.winid)[1]
    local meta = line_metadata[line_number]

    if not meta or meta.type ~= "module" then
      return
    end

    local module_name = meta.name
    local module_category = module_name:match("([^.]*)")
    if templates.templates[module_category] and templates.templates[module_category][module_name:gsub(module_category .. ".", "")] then
      local template_config = templates.templates[module_category][module_name:gsub(module_category .. ".", "")]
      config_manager.set_config(module_name, template_config)
      update_lines()
    else
      vim.notify("No template found for this module.", vim.log.levels.WARN)
    end
  end)

  popup:on({
    event = "BufLeave",
    callback = function()
      popup:unmount()
    end,
  })

  popup:map("n", "q", function()
    popup:unmount()
  end)
end

return M
