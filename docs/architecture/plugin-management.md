# NvCraft 插件管理系统

## 1. 概述

NvCraft 的插件管理系统基于 [lazy.nvim](https://github.com/folke/lazy.nvim)，并与 NvCraft 的模块化系统紧密集成。这种设计旨在简化插件管理，同时保持 `lazy.nvim` 的强大功能和性能。

## 2. 核心理念

- **模块驱动**: 插件由模块定义和管理，而不是集中在一个大的配置文件中。
- **自动管理**: NvCraft 核心系统负责收集所有已启用模块的插件，并将其传递给 `lazy.nvim` 进行处理。
- **无缝集成**: 用户仍然可以利用 `lazy.nvim` 的所有功能，如懒加载、版本锁定等。

## 3. 插件定义

每个模块都可以在其模块接口的 `plugins` 字段中定义一个插件列表。该列表的格式与 `lazy.nvim` 的插件规范完全兼容。

### 示例

在模块 `my_module.lua` 中：

```lua
return {
  name = "my_module",
  -- ...
  plugins = {
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.5",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        -- 插件配置
      end,
    },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  },
}
```

## 4. 工作流程

1.  **模块加载**: NvCraft 启动时，模块加载器会加载所有已启用的模块。
2.  **插件收集**: 核心系统遍历所有已加载的模块，并收集它们的 `plugins` 列表。
3.  **插件合并**: 所有插件列表被合并成一个单一的列表。
4.  **Lazy.nvim 初始化**: 合并后的插件列表被传递给 `lazy.nvim` 的 `setup` 函数。
5.  **插件管理**: `lazy.nvim` 负责处理插件的安装、加载、更新和依赖管理。

## 5. 优势

- **高内聚**: 插件与其相关的功能（模块）放在一起，使代码更易于理解和维护。
- **易于扩展**: 添加或删除一个模块会自动管理其相关的插件，无需手动修改插件列表。
- **灵活性**: 用户仍然可以创建自己的模块来添加或覆盖插件，从而实现完全的自定义。
- **性能**: 继承了 `lazy.nvim` 的懒加载和性能优化。
