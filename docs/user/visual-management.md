# Visual Management Guide

NvCraft provides a suite of visual management tools to help you configure and manage your Neovim environment with ease.

## Module Manager

The Module Manager provides an interactive interface to manage all available modules.

- **Command:** `:NvCraftModuleManager`
- **Features:**
  - List all modules and their status (enabled/disabled).
  - Enable or disable a module with `<CR>`.
  - Edit a module's configuration with `e`.
  - View module dependencies with `d`.
  - Search for modules with `/`.

## Configuration Editor

The Configuration Editor allows you to directly edit the JSON configuration for different parts of NvCraft.

- **Command:** `:NvCraftConfigEditor`

## Dashboard

The Dashboard is the central hub for your NvCraft environment, providing quick access to essential information and tools.

- **Command:** `:NvCraftDashboard`
- **Features:**
  - Displays a summary of the system's health status.
  - Provides a "Quick Actions" panel with shortcuts:
    - `m`: Open Module Manager
    - `c`: Open Config Editor
    - `h`: Open Health Check

## Health Check

The Health Check panel helps you diagnose issues and monitor the status of your Neovim setup.

- **Command:** `:NvCraftHealth`
- **Features:**
  - Checks the Neovim version for compatibility.
  - Runs health checks for all registered modules that provide a `health_check` function.
