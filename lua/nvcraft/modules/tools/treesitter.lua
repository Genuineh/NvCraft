return {
  name = "treesitter",
  version = "1.0.0",
  description = "Treesitter support for Neovim.",
  category = "tools",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "treesitter", "parsing" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "nvim-treesitter/nvim-treesitter",
      version = false,
      cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
      build = ":TSUpdate",
      event = { "LazyFile", "VeryLazy" },
      init = function(plugin)
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
      end,
      dependencies = {
        {
          "nvim-treesitter/nvim-treesitter-textobjects",
          config = function()
            local move = require("nvim-treesitter.textobjects.move")
            local configs = require("nvim-treesitter.configs")
            for name, fn in pairs(move) do
              if name:find("goto") == 1 then
                move[name] = function(q, ...)
                  if vim.wo.diff then
                    local config = configs.get_module("textobjects.move")[name]
                    for key, query in pairs(config or {}) do
                      if q == query and key:find("[%]%[][cC]") then
                        vim.cmd("normal! " .. key)
                        return
                      end
                    end
                  end
                  return fn(q, ...)
                end
              end
            end
          end,
        },
      },
    },
  },
  setup = function()
    require("nvim-treesitter.configs").setup({
      modules = {},
      ensure_installed = {
        "c",
        "cpp",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "xml",
        "c_sharp",
        "yaml",
        "go",
        "typescript",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "rust",
      },
      sync_install = false,
      auto_install = true,
      ignore_install = { "javascript" },
      highlight = {
        enable = true,
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    })
  end,
  keys = {
    { "<c-space>", desc = "Increment selection" },
    { "<bs>", desc = "Decrement selection", mode = "x" },
  },
}
