local path = ""

local uiSetup = function()
  local dap, dapui = require("dap"), require("dapui")

  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    mappings = {
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      edit = "e",
      repl = "r",
      toggle = "t",
    },
    element_mappings = {},
    expand_lines = vim.fn.has("nvim-0.7") == 1,
    layouts = {
      {
        elements = { "scopes" },
        size = 0.25,
        position = "bottom",
      },
      {
        elements = { "repl", "console" },
        size = 40,
        position = "right",
      },
    },
    controls = {
      enabled = true,
      element = "repl",
      icons = {
        pause = "",
        play = "",
        step_into = "",
        step_over = "",
        step_out = "",
        step_back = "",
        run_last = "↻",
        terminate = "□",
      },
    },
    floating = {
      max_height = nil,
      max_width = nil,
      border = "single",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    windows = { indent = 1 },
    render = {
      max_type_length = nil,
      max_value_lines = 100,
    },
  })

  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

return {
  name = "dap",
  version = "1.0.0",
  description = "Debug Adapter Protocol support.",
  category = "lsp",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "dap", "debugging" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        {
          "rcarriga/nvim-dap-ui",
          dependencies = { "nvim-neotest/nvim-nio" },
          config = uiSetup,
        },
        {
          "theHamsta/nvim-dap-virtual-text",
          opts = {},
        },
      },
    },
  },
  setup = function()
    local dap = require("dap")

    dap.adapters.netcoredbg = {
      type = "executable",
      command = "/home/jerryg/dap_adapter/netcoredbg/netcoredbg",
      args = { "--interpreter=vscode" },
    }

    dap.adapters.dart = {
      type = "executable",
      command = "dart",
      args = { "debug_adapter" },
    }

    dap.adapters.flutter = {
      type = "executable",
      command = "flutter",
      args = { "debug_adapter" },
    }

    if not dap.adapters["codelldb"] then
      require("dap").adapters["codelldb"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = {
            "--port",
            "${port}",
          },
        },
      }
    end

    for _, lang in ipairs({ "c", "cpp" }) do
      dap.configurations[lang] = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          pid = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end

    dap.configurations.rust = dap.configurations.cpp

    dap.configurations.cs = {
      {
        type = "netcoredbg",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          local launch_json_path = vim.fn.getcwd() .. "/.vscode/launch.json"
          if vim.fn.filereadable(launch_json_path) == 1 then
            local content = vim.fn.join(vim.fn.readfile(launch_json_path), "\n")
            content = content:gsub("^%s*", ""):gsub("^[\239\187\191]", "")
            local status, launch_config = pcall(function()
              return vim.fn.json_decode(content)
            end)
            if status and launch_config and launch_config.configurations then
              for _, config in ipairs(launch_config.configurations) do
                if config.type == "coreclr" and config.request == "launch" and config.program then
                  return config.program
                end
              end
            else
              vim.notify("Failed to parse launch.json, falling back to manual input", vim.log.levels.WARN)
            end
          end
          if path ~= "" then
            return path
          end
          return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
      },
    }
  end,
  keys = {
    {
      mode = { "n" },
      "<leader>dw",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "Widgets",
    },
    { mode = { "n" }, "<leader>dt", "<Cmd>lua require('dap').terminate()<CR>", desc = "debug terminate" },
    { mode = { "n" }, "<leader>dc", "<Cmd>lua require('dap').continue()<CR>", desc = "debug run/continue" },
    { mode = { "n" }, "<leader>dC", "<Cmd>lua require('dap').run_to_cursor()<CR>", desc = "debug run to cursor" },
    { mode = { "n" }, "<leader>do", "<Cmd>lua require('dap').step_over()<CR>", desc = "debug step over" },
    { mode = { "n" }, "<leader>di", "<Cmd>lua require('dap').step_into()<CR>", desc = "debug step into" },
    { mode = { "n" }, "<leader>dO", "<Cmd>lua require('dap').step_out()<CR>", desc = "debug step out" },
    {
      mode = { "n" },
      "<leader>db",
      "<Cmd>lua require('dap').toggle_breakpoint()<CR>",
      desc = "debug toggle breakpoint",
    },
    { mode = { "n" }, "<leader>dr", "<Cmd>lua require('dap').repl.open()<CR>", desc = "debug open repl" },
    { mode = { "n" }, "<leader>dl", "<Cmd>lua require('dap').run_last()<CR>", desc = "debug run last" },
    {
      mode = { "n" },
      "<leader>dB",
      "<Cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint config: '))<CR>",
    },
    {
      mode = { "n" },
      "<leader>dp",
      "<Cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    },
    {
      mode = { "n" },
      "<leader>dsp",
      function()
        local tmp_path = vim.fn.input("Set debug path: ", vim.fn.getcwd(), "file")
        path = tmp_path
        vim.notify(string.format("Set debug path: %s", path))
      end,
      desc = "Set debug path",
    },
    {
      "<leader>td",
      function()
        require("neotest").summary.close()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Debug test",
    },
    {
      "<leader>du",
      function()
        require("dapui").toggle({})
      end,
      desc = "Dap UI",
    },
    {
      "<leader>de",
      function()
        require("dapui").eval()
      end,
      desc = "Eval",
      mode = { "n", "v" },
    },
  },
}
