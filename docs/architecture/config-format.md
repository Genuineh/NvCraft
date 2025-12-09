# NvCraft 配置文件格式

## 1. 概述

NvCraft 采用分层配置系统，允许用户在不同级别上进行灵活的配置。配置文件格式设计旨在简单、直观且易于管理。

## 2. 配置文件格式

NvCraft 支持多种配置文件格式，但推荐使用 YAML，因为它具有更好的可读性。

- **YAML (.yml)**: 推荐格式，简洁易读。
- **JSON (.json)**: 备选格式，适合程序化处理。

## 3. 配置层级

NvCraft 的配置分为三个层级，优先级从高到低依次为：

1.  **项目级配置 (`.nvcraft/config.yml`)**:
    - 位于项目根目录。
    - 特定于当前项目，会覆盖全局和用户级配置。
    - 适合团队共享的项目特定设置。

2.  **用户级配置 (`~/.config/nvcraft/config.yml`)**:
    - 用户全局配置。
    - 适用于所有项目，除非被项目级配置覆盖。

3.  **默认配置**:
    - NvCraft 内置的默认配置。
    - 优先级最低。

## 4. 配置文件结构

配置文件是一个包含模块配置的映射。每个键都是模块的 `name`，值是该模块的配置。

### 示例 (`config.yml`)

```yaml
# 全局设置
theme: "catppuccin"
ui:
  font_size: 12

# 模块配置
completion:
  enable: true
  backend: "copilot"

git:
  enable: true
  signs:
    enable: true

formatter:
  enable: true
  auto_format_on_save: true
```

## 5. 配置加载和合并

- NvCraft 启动时，会按“默认 -> 用户级 -> 项目级”的顺序加载配置。
- 后加载的配置会深度合并（deep merge）到先加载的配置中，实现配置覆盖。

## 6. 配置验证

- 每个模块都可以定义一个 `config_schema`，用于描述其配置选项。
- 配置加载后，NvCraft 会使用此 schema 验证用户配置。
- 如果配置无效，将向用户显示错误或警告信息。
