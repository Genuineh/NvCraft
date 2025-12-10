local lsp = require("nvcraft.core.lsp")

return {
  name = "fuzzy",
  version = "1.0.0",
  description = "Fuzzy finding with FZF.",
  category = "files",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "fuzzy", "fzf" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "ibhagwan/fzf-lua",
      cmd = "FzfLua",
      event = "VeryLazy",
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
  },
  opts = {
    "default-title",
    fzf_colors = true,
    fzf_opts = {
      ["--no-scrollbar"] = true,
    },
    defaults = {
      formatter = "path.dirname_first",
    },
    ui_select = function(fzf_opts, items)
      return vim.tbl_deep_extend("force", fzf_opts, {
        prompt = " ",
        winopts = {
          title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
          title_pos = "center",
        },
      }, fzf_opts.kind == "codeaction" and {
        winopts = {
          layout = "vertical",
          height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
          width = 0.5,
          preview = not vim.tbl_isempty(lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
            layout = "vertical",
            vertical = "down:15,border-top",
            hidden = "hidden",
          } or {
            layout = "vertical",
            vertical = "down:15,border-top",
          },
        },
      } or {
        winopts = {
          width = 0.5,
          height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
        },
      })
    end,
    winopts = {
      width = 0.8,
      height = 0.8,
      row = 0.5,
      col = 0.5,
      preview = {
        scrollchars = { "┃", "" },
      },
    },
    lsp = {
      symbols = {
        symbol_hl = function(s)
          return "TroubleIcon" .. s
        end,
        symbol_fmt = function(s)
          return s:lower() .. "\t"
        end,
        child_prefix = false,
      },
      code_actions = {
        previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
      },
    },
  },
  config = function(_, opts)
    local runtime = require("nvcraft.core.runtime")
    local fzf = require("fzf-lua")
    local config = fzf.config
    local actions = fzf.actions

    config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
    config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
    config.defaults.keymap.fzf["ctrl-x"] = "jump"
    config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
    config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
    config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
    config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

    if runtime.modules_has("trouble") then
      config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
    end

    config.defaults.actions.files["ctrl-r"] = function(_, ctx)
      local o = vim.deepcopy(ctx.__call_opts)
      o.root = o.root == false
      o.cwd = nil
      o.buf = ctx.__CTX.bufnr
      fzf[ctx.__INFO.cmd](o)
    end

    config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
    config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

    local img_previewer
    for _, v in ipairs({
      { cmd = "ueberzug", args = {} },
      { cmd = "chafa", args = { "{file}", "--format=symbols" } },
      { cmd = "viu", args = { "-b" } },
    }) do
      if vim.fn.executable(v.cmd) == 1 then
        img_previewer = vim.list_extend({ v.cmd }, v.args)
        break
      end
    end

    opts.previewers = {
      builtin = {
        extensions = {
          ["png"] = img_previewer,
          ["jpg"] = img_previewer,
          ["jpeg"] = img_previewer,
          ["gif"] = img_previewer,
          ["webp"] = img_previewer,
        },
        ueberzug_scaler = "fit_contain",
      },
    }

    opts.files = {
      cwd_prompt = false,
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    }

    opts.grep = {
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    }

    if opts[1] == "default-title" then
      local function fix(t)
        t.prompt = t.prompt ~= nil and " " or nil
        for _, v in pairs(t) do
          if type(v) == "table" then
            fix(v)
          end
        end
        return t
      end
      opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
      opts[1] = nil
    end
    require("fzf-lua").setup(opts)
  end,
  init = function()
    vim.ui.select = function(...)
      require("fzf-lua").register_ui_select(_opts.ui_select or nil)
      return vim.ui.select(...)
    end
  end,
  keys = {
    { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
    { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
    { "<leader>faf", "<cmd>FzfLua files cwd=~ <cr>", desc = "find files from home" },
    { "<leader>fiw", "<cmd>FzfLua files cwd=~/Work/ <cr>", desc = "find files from work" },
    { "<leader>fig", "<cmd>FzfLua files cwd=~/github/ <cr>", desc = "find files from github" },
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "find files" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "live grep" },
    {
      "<leader>fb",
      "<cmd>FzfLua buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
      desc = "buffers",
    },
    {
      "<leader>,",
      "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch buffers",
    },
    { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "help_tags" },
    { "<leader>frs", "<cmd>FzfLua resume<cr>", desc = "resume" },
    { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "oldfiles" },
    { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Commits" },
    { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Status" },
    { "<leader>fsH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>fsj", "<cmd>FzfLua jumplist<cr>", desc = "Jumplist" },
    { "<leader>fsk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
    { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
  },
}
