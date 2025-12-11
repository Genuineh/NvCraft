-- This file defines a local lazy.nvim plugin that orchestrates the startup of NvCraft.
return {
  -- We don't need a name here as the directory serves as the identifier.
  dependencies = { "vhyrro/luarocks.nvim" },
  config = function()
    -- By the time this function runs, lazy.nvim guarantees that all dependencies,
    -- including luarocks.nvim and its installed rocks, are ready.

    -- Now, we can safely initialize the rest of NvCraft.
    local registry = require("nvcraft.core.registry")
    registry.setup()

    local loader = require("nvcraft.core.loader")
    loader.load_modules()

    -- And finally, setup the commands module now that everything else is loaded.
    local ok, commands_mod = pcall(require, "nvcraft.modules.base.commands")
    if ok and commands_mod.setup then
      commands_mod.setup()
    else
      vim.notify("Failed to setup NvCraft user commands.", vim.log.levels.ERROR)
    end
  end,
}
