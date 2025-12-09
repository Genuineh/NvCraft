# NvCraft 模块接口标准

## 1. 概述

NvCraft 的模块接口旨在提供一个统一、可扩展且易于理解的模块定义标准。所有模块都应遵循此接口，以确保一致性和互操作性。

## 2. 模块结构

每个模块都是一个返回 Lua 表的 Lua 文件。该表包含模块的元数据、配置、插件、设置等信息。

```lua
return {
  name = "module_name",
  version = "1.0.0",
  description = "模块的简要描述",
  category = "editor", -- 模块分类
  dependencies = { "dependency1", "dependency2" },

  -- 元数据
  meta = {
    author = "作者",
    homepage = "项目主页",
    tags = { "tag1", "tag2" },
    enabled_by_default = true,
  },

  -- 配置 Schema
  config_schema = {
    -- 配置项定义
  },

  -- 插件定义
  plugins = {
    -- lazy.nvim 格式的插件列表
  },

  -- 设置函数
  setup = function(opts)
    -- 模块初始化逻辑
  end,

  -- 按键绑定
  keys = {
    -- 按键映射
  },

  -- 自动命令
  autocmds = {
    -- 自动命令
  },

  -- 健康检查
  health_check = function()
    -- 健康检查逻辑
  end,
}
```

## 3. 接口详解

### `name` (string, required)

模块的唯一标识符。命名应简洁明了，使用小写字母和下划线，例如 `file_explorer`。

### `version` (string, required)

模块的版本号，遵循 [语义化版本](https://semver.org/lang/zh-CN/) 规范（例如 `1.0.0`）。

### `description` (string, optional)

模块功能的简要描述。

### `category` (string, required)

模块的分类，用于在 UI 中组织和筛选模块。可选值包括：
- `base`: 核心功能
- `editor`: 编辑增强
- `lsp`: 语言支持
- `ui`: UI 组件
- `files`: 文件管理
- `git`: Git 集成
- `tools`: 外部工具
- `ai`: AI 助手
- `specialized`: 特定语言或框架支持

### `dependencies` (table, optional)

一个字符串列表，声明该模块依赖的其他模块的 `name`。模块加载器将确保在加载此模块之前先加载其依赖项。

### `meta` (table, optional)

包含模块元数据的表。

- `author` (string): 模块作者。
- `homepage` (string): 模块的项目主页 URL。
- `tags` (table): 与模块功能相关的标签字符串列表。
- `enabled_by_default` (boolean): 模块是否默认启用。

### `config_schema` (table, optional)

定义模块配置选项的 Schema。这用于配置验证和自动生成配置 UI。

```lua
config_schema = {
  enable = { type = "boolean", default = true, description = "启用/禁用模块" },
  feature_x = { type = "string", default = "default_value", description = "功能 X 的设置" },
}
```

### `plugins` (table, optional)

一个插件列表，采用 [lazy.nvim](https.github.com/folke/lazy.nvim) 的格式。这些插件将在模块加载时由插件管理器处理。

```lua
plugins = {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- 插件配置
    end,
  },
}
```

### `setup` (function, optional)

模块的初始化函数。在模块加载和插件配置之后调用。它接收一个参数 `opts`，其中包含用户为该模块提供的配置。

```lua
setup = function(opts)
  if opts.feature_x then
    -- 执行初始化
  end
end
```

### `keys` (table, optional)

模块的按键绑定。可以是单个按键映射或按键映射的列表。

```lua
keys = {
  { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
}
```

### `autocmds` (table, optional)

模块的自动命令。

```lua
autocmds = {
  { "BufEnter", "*.lua", "echo 'Entered a Lua file'" },
}
```

### `health_check` (function, optional)

一个用于健康检查的函数。它应该检查模块的依赖项（如外部可执行文件）是否可用，并返回检查结果。
