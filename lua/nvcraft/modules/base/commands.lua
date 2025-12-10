return {
  name = "commands",
  version = "1.0.0",
  description = "Defines NvCraft user commands.",
  category = "base",
  dependencies = {
    "ui.module_manager",
    "ui.config_editor",
    "ui.dashboard",
    "ui.health",
    "smart.detector",
    "smart.recommender",
    "smart.optimizer",
    "ui.wizard",
  },
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "commands", "core" },
    enabled_by_default = true,
  },
  setup = function()
    vim.api.nvim_create_user_command("NvCraftModuleManager", function()
      require("nvcraft.ui.module_manager").setup()
    end, {})

    vim.api.nvim_create_user_command("NvCraftConfigEditor", function()
      require("nvcraft.ui.config_editor").setup()
    end, {})

    vim.api.nvim_create_user_command("NvCraftDashboard", function()
      require("nvcraft.ui.dashboard").setup()
    end, {})

    vim.api.nvim_create_user_command("NvCraftHealth", function()
      require("nvcraft.ui.health").setup()
    end, {})

    vim.api.nvim_create_user_command("NvCraftSmartRecommend", function()
      local detector = require("nvcraft.smart.detector")
      local recommender = require("nvcraft.smart.recommender")

      local project_types = detector.detect_project_type()
      local languages = detector.detect_languages()
      local recommendations = recommender.recommend_modules()

      vim.notify(
        "Project Types: "
          .. table.concat(project_types, ", ")
          .. "\n"
          .. "Languages: "
          .. table.concat(languages, ", ")
          .. "\n"
          .. "Recommended Modules: "
          .. table.concat(recommendations, ", "),
        vim.log.levels.INFO,
        { title = "NvCraft Smart Recommendations" }
      )
    end, {})

    vim.api.nvim_create_user_command("NvCraftOptimize", function()
      require("nvcraft.smart.optimizer").show_suggestions()
    end, {})

    -- First time setup wizard
    vim.defer_fn(function()
      local config_manager = require("nvcraft.config.manager")
      local core_config = config_manager.get_config("nvcraft.core")
      if not core_config or not core_config.wizard_completed then
        require("nvcraft.ui.wizard").setup()
      end
    end, 100)
  end,
}
