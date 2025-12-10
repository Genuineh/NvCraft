return {
  name = "avante",
  version = "1.0.0",
  description = "AI code assistant using avante.nvim.",
  category = "ai",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "ai", "avante" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      version = false, -- 永远不要将此值设置为 "*"！永远不要！
      opts = {
        -- 在此处添加任何选项
        -- 例如
        -- provider = "openai",
        -- openai = {
        -- 	endpoint = "https://api.openai.com/v1",
        -- 	model = "gpt-4o", -- 您想要的模型（或使用 gpt-4o 等）
        -- 	timeout = 30000, -- 超时时间（毫秒），增加此值以适应推理模型
        -- 	temperature = 0,
        -- 	max_tokens = 8192, -- 增加此值以包括推理模型的推理令牌
        -- 	--reasoning_effort = "medium", -- low|medium|high，仅用于推理模型
        -- },
        provider = "copilot",
        providers = {
          copilot_gpt_5_mini = {
            __inherited_from = "copilot",
            model = "gpt-5-mini",
          },
          copilot_gpt_41 = {
            __inherited_from = "copilot",
            model = "gpt-4.1-2025-04-14",
          },
          copilot_gpt_4o = {
            __inherited_from = "copilot",
            model = "gpt-4o",
          },
          copilot_gemini = {
            __inherited_from = "copilot",
            model = "gemini-2.0-flash-001",
          },
          copilot_claude37_thought = {
            __inherited_from = "copilot",
            model = "claude-3.7-sonnet-thought",
          },
          copilot_claude35 = {
            __inherited_from = "copilot",
            model = "claude-3.5-sonnet",
          },
          copilot_claude37 = {
            __inherited_from = "copilot",
            model = "claude-3.7-sonnet",
          },
        },
      },
      -- 如果您想从源代码构建，请执行 `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- 对于 Windows
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- 以下依赖项是可选的，
        "echasnovski/mini.pick", -- 用于文件选择器提供者 mini.pick
        "ibhagwan/fzf-lua", -- 用于文件选择器提供者 fzf
        "nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
        {
          "zbirenbaum/copilot.lua", -- 用于 providers='copilot'
          requires = {
            "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
          },
          cmd = "Copilot",
          build = ":Copilot auth",
          opts = {
            suggestion = { enabled = true },
            panel = { enabled = true },
            filetypes = {
              markdown = true,
              help = true,
            },
          },
          event = "InsertEnter",
        },
        {
          -- 支持图像粘贴
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- 推荐设置
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- Windows 用户必需
              use_absolute_path = true,
            },
          },
        },
        {
          -- 如果您有 lazy=true，请确保正确设置
          "MeanderingProgrammer/render-markdown.nvim",
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },
  },
}
