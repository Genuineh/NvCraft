# NvCraft 示例

本目录包含各种示例，帮助你了解如何使用和扩展 NvCraft。

## 目录结构

```
examples/
├── modules/              # 模块示例
│   ├── module_template.lua    # 模块模板
│   ├── simple_example.lua     # 简单模块示例
│   └── complex_example.lua    # 复杂模块示例
└── configs/              # 配置示例（即将推出）
```

## 模块示例

### module_template.lua
完整的模块模板，包含所有可能的配置选项和注释。适合作为创建新模块的起点。

**用途**:
- 复制此文件到 `lua/core/modules/`
- 根据需要修改配置
- 在 `lua/core/init.lua` 中注册模块

### simple_example.lua
最简单的模块示例，展示基本的模块结构。

**特点**:
- 最少的配置
- 适合简单插件
- 易于理解

**示例插件**: which-key.nvim

### complex_example.lua
复杂的模块示例，展示高级功能。

**特点**:
- 包含依赖项
- 自定义快捷键
- 自动命令
- 条件加载

**示例插件**: neo-tree.nvim

## 如何使用示例

### 1. 查看示例

```bash
# 查看模块模板
nvim examples/modules/module_template.lua

# 查看简单示例
nvim examples/modules/simple_example.lua

# 查看复杂示例
nvim examples/modules/complex_example.lua
```

### 2. 创建新模块

```bash
# 复制模板
cp examples/modules/module_template.lua lua/core/modules/my_module.lua

# 编辑模块
nvim lua/core/modules/my_module.lua

# 在 init.lua 中注册
nvim lua/core/init.lua
# 在 _modules 表中添加 "my_module"
```

### 3. 测试模块

```bash
# 启动 Neovim
nvim

# 或重新加载配置
:Lazy reload
```

## 示例场景

### 场景 1: 添加简单插件

如果你想添加一个简单的插件（如 indent-blankline），使用简单示例作为参考：

```lua
return {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    opts = {
        -- 插件选项
    }
}
```

### 场景 2: 添加需要配置的插件

如果你想添加需要复杂配置的插件（如 LSP），使用复杂示例作为参考：

```lua
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
    },
    config = function()
        -- 详细配置
    end
}
```

### 场景 3: 添加需要快捷键的插件

```lua
return {
    "plugin/name",
    keys = {
        { "<leader>x", ":Command<CR>", desc = "描述" }
    },
    opts = {}
}
```

## 最佳实践

1. **从模板开始**: 使用 `module_template.lua` 作为起点
2. **保持简单**: 如果可能，使用简单的结构
3. **懒加载**: 使用适当的事件、命令或文件类型触发
4. **添加描述**: 为快捷键添加描述
5. **测试**: 创建模块后立即测试

## 相关文档

- [模块开发指南](../docs/dev/module-development.md)
- [贡献指南](../CONTRIBUTING.md)
- [API 参考](../docs/api/) (即将推出)

## 贡献示例

如果你有好的模块示例，欢迎贡献！

1. 在 `examples/modules/` 创建新的示例文件
2. 添加详细的注释
3. 在本 README 中添加说明
4. 提交 Pull Request

## 获取帮助

- 查看 [文档](../docs/)
- 提问 [Discussions](https://github.com/Genuineh/NvCraft/discussions)
- 报告问题 [Issues](https://github.com/Genuineh/NvCraft/issues)

---

**提示**: 这些示例是为了帮助理解，实际使用时可能需要根据插件的具体要求进行调整。
