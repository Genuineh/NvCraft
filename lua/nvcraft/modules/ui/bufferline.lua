return {
  name = "bufferline",
  version = "1.0.0",
  description = "A bufferline for Neovim.",
  category = "ui",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "bufferline", "ui" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "akinsho/bufferline.nvim",
      event = "VeryLazy",
      dependencies = {
        {
          "echasnovski/mini.bufremove",
          keys = {
            {
              "<leader>bd",
              function()
                local bd = require("mini.bufremove").delete
                if vim.bo.modified then
                  local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
                  if choice == 1 then -- Yes
                    vim.cmd.write()
                    bd(0)
                  elseif choice == 2 then -- No
                    bd(0, true)
                  end
                else
                  bd(0)
                end
              end,
              desc = "Delete Buffer",
            },
            -- stylua: ignore
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
          },
        },
      },
      opts = {
        options = {
          -- stylua: ignore
          close_command = function(n) require("mini.bufremove").delete(n, false) end,
          -- stylua: ignore
          right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
          diagnostics = "nvim_lsp",
          always_show_bufferline = false,
          offsets = {
            {
              filetype = "neo-tree",
              text = "Neo-tree",
              highlight = "Directory",
              text_align = "left",
            },
          },
        },
      },
      config = function(_, opts)
        require("bufferline").setup(opts)
        -- Fix bufferline when restoring a session
        vim.api.nvim_create_autocmd("BufAdd", {
          callback = function()
            vim.schedule(function()
              pcall(nvim_bufferline)
            end)
          end,
        })
      end,
    },
  },
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  },
}
