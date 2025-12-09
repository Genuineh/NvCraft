# 模块开发指南

本指南介绍如何为 NvCraft 开发新模块。

## 模块基础

### 什么是模块？

在 NvCraft 中，模块是独立的功能单元，封装了特定的功能或插件配置。每个模块通常对应一个或多个 Neovim 插件，以及相关的配置、快捷键和自动命令。

### 模块结构

标准模块文件结构：

```lua
-- lua/core/modules/example.lua

return {
    -- 插件仓库（必需）
    "author/plugin-name",
    
    -- 可选配置项
    version = "1.0.0",        -- 版本号
    branch = "main",          -- 分支名
    
    -- 依赖项
    dependencies = {
        "other/plugin",
        {
            "another/plugin",
            config = function()
                -- 依赖配置
            end
        }
    },
    
    -- 懒加载配置
    event = "VeryLazy",       -- 事件触发
    cmd = "CommandName",      -- 命令触发
    ft = "filetype",          -- 文件类型触发
    keys = { "<leader>x" },   -- 快捷键触发
    
    -- 插件选项
    opts = {
        -- 插件配置选项
        option1 = value1,
        option2 = value2,
    },
    
    -- 配置函数
    config = function(_, opts)
        require("plugin-name").setup(opts)
        -- 额外配置
    end,
    
    -- 初始化函数（在插件加载前执行）
    init = function()
        -- 预初始化代码
    end,
}
```

---

## 创建新模块

### 步骤 1: 创建模块文件

在 `lua/core/modules/` 目录下创建新文件：

```bash
touch ~/.config/nvim/lua/core/modules/my_module.lua
```

### 步骤 2: 定义模块

```lua
-- lua/core/modules/my_module.lua

return {
    "username/my-plugin",
    
    -- 基于事件懒加载
    event = "BufReadPost",
    
    -- 插件配置
    opts = {
        enable = true,
        features = {
            feature1 = true,
            feature2 = false,
        }
    },
    
    -- 快捷键配置
    keys = {
        {
            "<leader>mp",
            function()
                require("my-plugin").do_something()
            end,
            desc = "My Plugin: Do Something"
        }
    },
    
    -- 配置函数
    config = function(_, opts)
        local plugin = require("my-plugin")
        plugin.setup(opts)
        
        -- 额外配置
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*.txt",
            callback = function()
                print("Entering text file")
            end
        })
    end
}
```

### 步骤 3: 注册模块

在 `lua/core/init.lua` 的 `_modules` 表中添加模块名：

```lua
local _modules = {
    "base",
    "neotree",
    "my_module",  -- 添加新模块
    -- ...
}
```

### 步骤 4: 测试模块

重启 Neovim 或执行：
```vim
:Lazy reload
```

---

## 模块类型

### 1. 简单插件模块

仅包含插件和基础配置：

```lua
return {
    "author/simple-plugin",
    event = "VeryLazy",
    opts = {
        setting = true
    }
}
```

### 2. 带依赖的模块

依赖其他插件：

```lua
return {
    "author/main-plugin",
    dependencies = {
        "author/dependency1",
        "author/dependency2",
        {
            "author/dependency3",
            config = function()
                -- 依赖配置
            end
        }
    },
    config = function()
        require("main-plugin").setup()
    end
}
```

### 3. LSP 模块

语言服务器配置：

```lua
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        local lspconfig = require("lspconfig")
        
        -- 配置语言服务器
        lspconfig.pyright.setup({
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic"
                    }
                }
            }
        })
    end
}
```

### 4. UI 模块

用户界面插件：

```lua
return {
    "author/ui-plugin",
    lazy = false,  -- 立即加载
    priority = 1000,  -- 高优先级
    opts = {
        theme = "dark",
        icons = true
    },
    config = function(_, opts)
        require("ui-plugin").setup(opts)
    end
}
```

---

## 懒加载策略

### 事件触发

```lua
return {
    "author/plugin",
    event = "VeryLazy",  -- Neovim 启动完成后
    -- 或
    event = "BufReadPost",  -- 读取文件后
    -- 或
    event = { "BufReadPost", "BufNewFile" },  -- 多个事件
}
```

常用事件：
- `VeryLazy` - 启动完成后
- `BufReadPost` - 读取文件后
- `BufNewFile` - 新建文件
- `InsertEnter` - 进入插入模式
- `CmdlineEnter` - 进入命令行
- `LspAttach` - LSP 附加时

### 命令触发

```lua
return {
    "author/plugin",
    cmd = "MyCommand",  -- 执行 :MyCommand 时加载
    -- 或
    cmd = { "Command1", "Command2" },  -- 多个命令
}
```

### 文件类型触发

```lua
return {
    "author/plugin",
    ft = "python",  -- 打开 Python 文件时加载
    -- 或
    ft = { "python", "lua", "javascript" },  -- 多个类型
}
```

### 快捷键触发

```lua
return {
    "author/plugin",
    keys = {
        { "<leader>p", ":PluginCommand<CR>", desc = "Plugin Command" }
    }
}
```

---

## 配置选项

### opts vs config

**opts** - 简单配置：
```lua
opts = {
    option1 = true,
    option2 = "value"
}
-- 等同于
config = function(_, opts)
    require("plugin").setup(opts)
end
```

**config** - 复杂配置：
```lua
config = function(_, opts)
    local plugin = require("plugin")
    
    -- 修改选项
    opts.extra_option = true
    
    -- 设置插件
    plugin.setup(opts)
    
    -- 额外配置
    vim.api.nvim_set_keymap("n", "<leader>x", ":PluginCmd<CR>", {})
end
```

---

## 快捷键配置

### 模块内快捷键

```lua
return {
    "author/plugin",
    keys = {
        -- 简单快捷键
        { "<leader>p", ":Command<CR>", desc = "Description" },
        
        -- 带模式的快捷键
        { "<leader>p", ":Command<CR>", mode = "n", desc = "Normal mode" },
        { "<leader>p", ":Command<CR>", mode = "v", desc = "Visual mode" },
        
        -- 函数快捷键
        {
            "<leader>p",
            function()
                require("plugin").do_something()
            end,
            desc = "Do something"
        },
        
        -- 带条件的快捷键
        {
            "<leader>p",
            function()
                if condition then
                    require("plugin").action1()
                else
                    require("plugin").action2()
                end
            end,
            desc = "Conditional action"
        }
    }
}
```

### 在 config 中定义快捷键

```lua
config = function()
    local plugin = require("plugin")
    plugin.setup()
    
    -- 使用 vim.keymap.set
    vim.keymap.set("n", "<leader>p", function()
        plugin.do_something()
    end, { desc = "Do something" })
    
    -- 或使用 which-key（如果已安装）
    local wk = require("which-key")
    wk.register({
        ["<leader>p"] = {
            name = "Plugin",
            a = { ":PluginAction1<CR>", "Action 1" },
            b = { ":PluginAction2<CR>", "Action 2" },
        }
    })
end
```

---

## 自动命令

### 在模块中定义

```lua
config = function()
    -- 创建自动命令组
    local augroup = vim.api.nvim_create_augroup("MyPlugin", { clear = true })
    
    -- 添加自动命令
    vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        pattern = "*.lua",
        callback = function()
            print("Entering Lua file")
        end
    })
    
    -- 多个事件
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = augroup,
        pattern = "*.md",
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.spell = true
        end
    })
end
```

---

## 最佳实践

### 1. 模块命名

- 使用小写字母和下划线：`my_module.lua`
- 名称应描述功能：`code_completion.lua`
- 避免使用插件名：用 `file_explorer.lua` 而不是 `neotree.lua`

### 2. 依赖管理

```lua
-- 好的做法
dependencies = {
    "required/plugin1",
    {
        "required/plugin2",
        config = function()
            -- 依赖配置
        end
    }
}

-- 避免循环依赖
-- 模块 A 依赖 B，模块 B 不应依赖 A
```

### 3. 性能优化

```lua
-- 懒加载
event = "VeryLazy",  -- 延迟加载

-- 条件加载
cond = function()
    return vim.fn.executable("tool") == 1
end,

-- 优先级（较少使用）
priority = 50,  -- 默认是 50，越大越早加载
```

### 4. 错误处理

```lua
config = function()
    local ok, plugin = pcall(require, "plugin")
    if not ok then
        vim.notify("Failed to load plugin", vim.log.levels.ERROR)
        return
    end
    
    plugin.setup({
        -- 配置
    })
end
```

### 5. 文档注释

```lua
-- lua/core/modules/my_module.lua

---@brief [[
--- 模块描述：这个模块提供了...
--- 依赖：需要安装 tool1 和 tool2
--- 配置：参见 opts 部分
---@brief ]]

return {
    "author/plugin",
    -- ...
}
```

---

## 调试技巧

### 查看插件状态

```vim
:Lazy  " 打开 lazy.nvim 界面
:Lazy log  " 查看日志
:Lazy profile  " 查看性能分析
```

### 打印调试信息

```lua
config = function()
    print("Configuring plugin...")
    vim.notify("Plugin loaded", vim.log.levels.INFO)
    
    -- 查看变量
    print(vim.inspect(some_variable))
end
```

### 检查模块加载

```vim
:lua print(package.loaded["plugin-name"])
```

---

## 示例：完整模块

```lua
-- lua/core/modules/my_editor.lua

return {
    -- 插件信息
    "author/my-editor-plugin",
    version = "2.0.0",
    
    -- 依赖
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "author/ui-lib",
            config = function()
                require("ui-lib").setup()
            end
        }
    },
    
    -- 懒加载
    event = "BufReadPost",
    cmd = { "MyEditor", "MyEditorOpen" },
    
    -- 选项
    opts = {
        enable_feature_a = true,
        enable_feature_b = false,
        theme = "dark",
        keymaps = {
            open = "<leader>me",
            close = "<leader>mq",
        }
    },
    
    -- 快捷键
    keys = {
        {
            "<leader>me",
            function()
                require("my-editor-plugin").open()
            end,
            desc = "Open My Editor"
        },
        {
            "<leader>mq",
            function()
                require("my-editor-plugin").close()
            end,
            desc = "Close My Editor"
        }
    },
    
    -- 配置
    config = function(_, opts)
        local plugin = require("my-editor-plugin")
        
        -- 设置插件
        plugin.setup(opts)
        
        -- 自动命令
        local augroup = vim.api.nvim_create_augroup("MyEditor", { clear = true })
        
        vim.api.nvim_create_autocmd("FileType", {
            group = augroup,
            pattern = { "markdown", "text" },
            callback = function()
                plugin.enable_for_buffer()
            end
        })
        
        -- 额外快捷键
        vim.keymap.set("n", "<leader>mt", function()
            plugin.toggle()
        end, { desc = "Toggle My Editor" })
    end,
    
    -- 初始化
    init = function()
        -- 在插件加载前设置
        vim.g.my_editor_config = "custom"
    end
}
```

---

## 下一步

- 📖 查看[现有模块](../../lua/core/modules/)获取灵感
- 🔧 阅读 [lazy.nvim 文档](https://github.com/folke/lazy.nvim)
- 💡 参考 [LazyVim 插件](https://www.lazyvim.org/plugins)
- 🤝 分享你的模块到社区

---

有问题？查看 [贡献指南](../../CONTRIBUTING.md) 或在 [Discussions](https://github.com/Genuineh/NvCraft/discussions) 提问。
