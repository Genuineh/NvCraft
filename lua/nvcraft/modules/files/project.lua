local pick = nil

local set_project_root = function(path)
  local runtime = require("nvcraft.core.runtime")
  runtime.set_project_root(path)
end

local change_root = function()
  local current_path = vim.fn.expand("%:p")
  set_project_root(current_path)
end

local select = function(selected, opts)
  local fzf = require("fzf-lua")
  local entry = fzf.path.entry_to_file(selected[1], opts, opts._uri)
  local fullpath = entry.bufname or entry.uri and entry.uri:match("^%a+://(.*)") or entry.path
  set_project_root(fullpath)
  return fzf.actions.file_edit_or_qf(selected, opts)
end

pick = function()
  local runtime = require("nvcraft.core.runtime")
  if runtime.modules_has("fzf") then
    local fzf_lua = require("fzf-lua")
    local history = require("project_nvim.utils.history")
    local results = history.get_recent_projects()
    local utils = require("fzf-lua.utils")

    local function hl_validate(hl)
      return not utils.is_hl_cleared(hl) and hl or nil
    end

    local function ansi_from_hl(hl, s)
      return utils.ansi_from_hl(hl_validate(hl), s)
    end

    local opts = {
      fzf_opts = {
        ["--header"] = string.format(
          ":: <%s> to %s | <%s> to %s | <%s> to %s | <%s> to %s",
          ansi_from_hl("FzfLuaHeaderBind", "ctrl-t"),
          ansi_from_hl("FzfLuaHeaderText", "tabedit"),
          ansi_from_hl("FzfLuaHeaderBind", "ctrl-s"),
          ansi_from_hl("FzfLuaHeaderText", "live_grep"),
          ansi_from_hl("FzfLuaHeaderBind", "ctrl-r"),
          ansi_from_hl("FzfLuaHeaderText", "oldfiles"),
          ansi_from_hl("FzfLuaHeaderBind", "ctrl-d"),
          ansi_from_hl("FzfLuaHeaderText", "delete")
        ),
      },
      fzf_colors = true,
      actions = {
        ["default"] = {
          function(selected)
            fzf_lua.files({
              actions = {
                ["default"] = select,
              },
              cwd = selected[1],
            })
          end,
        },
        ["ctrl-t"] = {
          function(selected)
            vim.cmd("tabedit")
            fzf_lua.files({ cwd = selected[1] })
          end,
        },
        ["ctrl-s"] = {
          function(selected)
            fzf_lua.live_grep({ cwd = selected[1] })
          end,
        },
        ["ctrl-r"] = {
          function(selected)
            fzf_lua.oldfiles({ cwd = selected[1] })
          end,
        },
        ["ctrl-d"] = function(selected)
          local path = selected[1]
          local choice = vim.fn.confirm("Delete '" .. path .. "' project? ", "&Yes\n&No")
          if choice == 1 then
            history.delete_project({ value = path })
          end
          pick()
        end,
      },
    }
    fzf_lua.fzf_exec(results, opts)
  end
end

return {
  name = "project",
  version = "1.0.0",
  description = "Project management for Neovim.",
  category = "files",
  dependencies = { "fuzzy" },
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "project", "files" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "ahmedkhalf/project.nvim",
      opts = {
        manual_mode = false,
        detection_methods = { "lsp", "pattern" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "*.sln" },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "global",
        datapath = vim.fn.stdpath("data"),
      },
      config = function(_, opts)
        require("project_nvim").setup(opts)
        local history = require("project_nvim.utils.history")
        history.delete_project = function(project)
          for k, v in pairs(history.recent_projects) do
            if v == project.value then
              history.recent_projects[k] = nil
              return
            end
          end
        end
      end,
    },
  },
  keys = {
    { "<leader>fp", pick, desc = "Projects" },
    { "<leader>rc", change_root, desc = "Root change" },
  },
}
