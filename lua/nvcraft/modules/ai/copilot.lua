return {
  name = "copilot",
  version = "1.0.0",
  description = "Copilot support.",
  category = "ai",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "copilot", "ai" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "main",
      cmd = "CopilotChat",
      dependencies = {
        {
          "zbirenbaum/copilot.lua",
          cmd = "Copilot",
          build = ":Copilot auth",
          opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
              markdown = true,
              help = true,
            },
          },
        },
        {
          "nvim-lua/plenary.nvim",
        },
      },
      opts = function()
        local user = vim.env.USER or "User"
        user = user:sub(1, 1):upper() .. user:sub(2)
        return {
          model = "claude-3.7-sonnet",
          auto_insert_mode = true,
          question_header = "  " .. user .. " ",
          answer_header = "  Copilot ",
          window = {
            width = 0.4,
          },
        }
      end,
      config = function(_, opts)
        local chat = require("CopilotChat")
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "copilot-chat",
          callback = function()
            vim.opt_local.relativenumber = false
            vim.opt_local.number = false
          end,
        })
        chat.setup(opts)
      end,
    },
  },
  keys = {
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
    {
      "<leader>at",
      function()
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>ax",
      function()
        return require("CopilotChat").reset()
      end,
      desc = "Clear (CopilotChat)",
      mode = { "n", "v" },
    },
    {
      "<leader>ccq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
      end,
      desc = "CopilotChat - Quick chat",
    },
    {
      "<leader>aq",
      function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end,
      desc = "Quick Chat (CopilotChat)",
      mode = { "n", "v" },
    },
    { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
  },
}
