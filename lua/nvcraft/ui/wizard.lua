-- lua/nvcraft/ui/wizard.lua
-- Onboarding wizard for NvCraft.

local NuiPopup = require("nui.popup")
local NuiLine = require("nui.line")
local NuiText = require("nui.text")
local NuiButton = require("nui.button")
local config_manager = require("nvcraft.config.manager")
local templates = require("nvcraft.config.templates").templates

local M = {}

local wizard_state = {
  current_step = 1,
  selections = {
    modules = {},
    theme = nil,
    keymap_profile = nil,
  },
}

-- Placeholder logo
local logo = {
  [[ __  __   ____  __          __  _ ]],
  [[ \ \/ /  / __/ / /_  ____  / /_(_)___   ___  ]],
  [[  \  /  / /_  / __/ / __ \/ __// // _ \ / _ \ ]],
  [[  / /  / __/ / /_  / /_/ / /_ / //  __//  __/ ]],
  [[ /_/  /_/    \__/  \____/\__//_/ \___/ \___/  ]],
}

local popup

-- Forward declaration for circular dependency
local steps

local function render_current_step()
  if not popup or not popup.bufnr then
    return
  end

  local step_definition = steps[wizard_state.current_step]
  if not step_definition then
    return
  end

  -- Clear buffer
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, {})

  -- Render content
  local lines = step_definition.render()
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, lines)

  -- Update title
  popup:set_title(string.format("NvCraft Setup Wizard (%d/%d): %s", wizard_state.current_step, #steps, step_definition.title), "center")

  -- Render navigation buttons conditionally
  local nav_buttons = {}
  if wizard_state.current_step > 1 then
    table.insert(nav_buttons, NuiButton(" < Previous ", { on_press = prev_step }))
  end

  if wizard_state.current_step < #steps then
    if #nav_buttons > 0 then
      table.insert(nav_buttons, NuiText(" | ", "Separator"))
    end
    table.insert(nav_buttons, NuiButton(" Next > ", { on_press = next_step }))
  end

  if wizard_state.current_step == #steps then
    if #nav_buttons > 0 then
      table.insert(nav_buttons, NuiText(" | ", "Separator"))
    end
    table.insert(nav_buttons, NuiButton(" Finish ", {
      on_press = function()
        apply_config()
        popup:unmount()
      end,
    }))
  end

  popup:find_or_create_win("bottom"):mount(NuiLine(nav_buttons))
end

local function next_step()
  if wizard_state.current_step < #steps then
    -- Call 'on_leave' hook of the current step if it exists
    local current_step_def = steps[wizard_state.current_step]
    if current_step_def.on_leave then
      current_step_def.on_leave()
    end

    wizard_state.current_step = wizard_state.current_step + 1
    render_current_step()
  end
end

local function prev_step()
  if wizard_state.current_step > 1 then
    wizard_state.current_step = wizard_state.current_step - 1
    render_current_step()
  end
end

local function apply_config()
  local selections = wizard_state.selections

  -- Apply theme
  if selections.theme then
    config_manager.set_config("colorscheme", { plugin = selections.theme })
  end

  -- Apply keymap profile
  if selections.keymap_profile then
    config_manager.set_config("keymaps", { profile = selections.keymap_profile })
  end

  -- Apply module selections from the chosen profile
  if selections.modules and #selections.modules > 0 then
    -- First, disable all modules to ensure a clean slate
    local ok, registry = pcall(require, "nvcraft.core.registry")
    if ok and registry then
      local all_modules = registry.get_modules()
      for _, module_name in ipairs(all_modules) do
        config_manager.set_config(module_name, { enabled = false })
      end
    end

    -- Then, enable the selected modules
    for _, module_name in ipairs(selections.modules) do
      config_manager.set_config(module_name, { enabled = true })
    end
  end

  -- Update core config with profile and completion status
  local core_config = config_manager.get_config("nvcraft.core") or {}
  if selections.module_profile then
    core_config.module_profile = selections.module_profile
  end
  core_config.wizard_completed = true
  config_manager.set_config("nvcraft.core", core_config)

  vim.notify("Configuration applied! Restart Neovim for changes to take full effect.", vim.log.levels.INFO)
end

-- Define the steps of the wizard
steps = {
  {
    title = "Welcome",
    render = function()
      local lines = {}
      for _, logoline in ipairs(logo) do
        table.insert(lines, NuiText(logoline, "DashboardLogo"))
      end
      table.insert(lines, NuiLine(""))
      table.insert(lines, NuiText("Welcome to NvCraft!"))
      table.insert(lines, NuiText("This wizard will guide you through the initial setup."))
      table.insert(lines, NuiLine(""))
      return lines
    end,
  },
  {
    title = "Module Selection",
    render = function()
      local lines = {
        NuiText("Select a base profile for module recommendations:"),
        NuiLine(""),
      }
      for i, profile in ipairs(templates.module_profiles) do
        local radio = wizard_state.selections.module_profile == profile.id and "[x]" or "[ ]"
        table.insert(
          lines,
          NuiLine(string.format("  %d. %s %s", i, radio, profile.name), {
            on_press = function()
              wizard_state.selections.module_profile = profile.id
              wizard_state.selections.modules = profile.modules
              render_current_step()
            end,
          })
        )
        table.insert(lines, NuiText(string.format("     %s", profile.description), "Comment"))
      end
      return lines
    end,
  },
  {
    title = "Theme Selection",
    render = function()
      local lines = { NuiText("Choose your preferred colorscheme:") }
      for i, theme in ipairs(templates.themes) do
        local radio = wizard_state.selections.theme == theme.name and "[x]" or "[ ]"
        table.insert(
          lines,
          NuiLine(string.format("  %d. %s %s", i, radio, theme.name), {
            on_press = function()
              wizard_state.selections.theme = theme.name
              -- Attempt to apply the theme live for preview
              pcall(vim.cmd.colorscheme, theme.name)
              render_current_step()
            end,
          })
        )
      end
      return lines
    end,
  },
  {
    title = "Keymap Profile",
    render = function()
      local lines = { NuiText("Select your keymap profile:") }
      for i, profile in ipairs(templates.keymap_profiles) do
        local radio = wizard_state.selections.keymap_profile == profile.id and "[x]" or "[ ]"
        table.insert(
          lines,
          NuiLine(string.format("  %d. %s %s", i, radio, profile.name), {
            on_press = function()
              wizard_state.selections.keymap_profile = profile.id
              render_current_step()
            end,
          })
        )
        table.insert(lines, NuiText(string.format("     %s", profile.description), "Comment"))
      end
      return lines
    end,
  },
  {
    title = "Finish",
    render = function()
      local summary = {
        NuiText("Setup Complete!", "Title"),
        NuiLine(""),
        NuiText("Your selections:", "DashboardHeader"),
        NuiText(string.format("  - Theme: %s", wizard_state.selections.theme or "default")),
        NuiText(string.format("  - Keymap Profile: %s", wizard_state.selections.keymap_profile or "default")),
        NuiText(string.format("  - Modules Profile: %s", wizard_state.selections.module_profile or "none")),
        NuiLine(""),
        NuiText("Click 'Finish' to apply the configuration."),
        NuiText("You may need to restart Neovim for all changes to take effect."),
      }
      return summary
    end,
  },
}

function M.setup()
  popup = NuiPopup({
    enter = true,
    focusable = true,
    border = { style = "rounded" },
    position = "50%",
    size = { width = "80%", height = "80%" },
  })

  popup:on({
    event = "BufLeave",
    callback = function()
      popup:unmount()
    end,
  })

  popup:map("n", "q", function()
    popup:unmount()
  end)

  popup:mount()
  render_current_step()
end

return M
