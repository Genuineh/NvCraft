# NvCraft 元数据系统

## 1. 概述

NvCraft 的元数据系统旨在为模块提供丰富的描述性信息。这些元数据不仅用于在用户界面中显示，还用于模块发现、依赖管理、智能推荐等高级功能。

## 2. 元数据来源

模块的元数据主要定义在模块接口的 `meta` 字段中。

### 示例

```lua
return {
  name = "my_module",
  version = "1.0.0",
  description = "这是一个示例模块",
  category = "tools",
  -- ...

  meta = {
    author = "NvCraft Team",
    homepage = "https://github.com/nvcraft/nvcraft",
    tags = { "tool", "example", "development" },
    enabled_by_default = true,
  },

  -- ...
}
```

## 3. 元数据结构

`meta` 表包含以下字段：

- `author` (string): 模块作者。
- `homepage` (string): 模块的项目主页或文档 URL。
- `tags` (table): 一个字符串列表，包含描述模块功能的标签。这对于搜索和分类非常有用。
- `enabled_by_default` (boolean): 指示模块是否在默认配置中启用。

## 4. 元数据的使用

### 4.1 模块管理器 UI

模块管理器 UI 使用元数据来丰富模块列表的显示信息，例如：
- 显示模块的作者和版本。
- 提供指向项目主页的链接。
- 使用标签进行筛选和搜索。

### 4.2 智能推荐

智能推荐系统可以利用元数据来：
- 基于项目类型和文件内容推荐相关模块（例如，如果检测到 `package.json`，则推荐 `npm` 相关的模块）。
- 根据用户的编辑习惯推荐模块。

### 4.3 文档生成

元数据可以用于自动生成模块市场或文档网站，提供所有可用模块的概览。
