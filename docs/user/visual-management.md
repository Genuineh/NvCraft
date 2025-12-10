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
  - Displays a startup logo and a summary of the system's health status.
  - **Quick Actions Panel:**
    - `m`: Open Module Manager
    - `c`: Open Config Editor
    - `h`: Open Health Check
  - **Statistics Panel:**
    - Shows the number of loaded modules.
    - Displays the Neovim startup time.
  - **Recent Projects Panel:**
    - Lists recently opened projects.
    - Press a number key (`1`-`9`) to switch to that project directory.

## Health Check

The Health Check panel helps you diagnose issues and monitor the status of your Neovim setup.

- **Command:** `:NvCraftHealth`
- **Features:**
  - **System Health:** Checks Neovim version and runs health checks for all registered modules.
  - **Performance Analysis:** Reports the Neovim startup time.
  - **Problem Diagnostics:** A section for future diagnostic tools.
