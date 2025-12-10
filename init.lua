vim.g.nvcraft_start_time = vim.v.t_start

-- Setup package path to find our modules
local config_path = vim.fn.stdpath("config")
package.path = package.path .. ";" .. config_path .. "/lua/?.lua;" .. config_path .. "/lua/?/init.lua"

-- Load and initialize the core system
require("nvcraft.core").Load()
