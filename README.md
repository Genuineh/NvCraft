# NvCraft

<div align="center">

🚀 **高度模块化、智能化的 Neovim 配置框架** 🚀

[![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg?style=flat-square&logo=neovim)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-5.1+-blue.svg?style=flat-square&logo=lua)](https://www.lua.org)
[![License](https://img.shields.io/github/license/Genuineh/NvCraft?style=flat-square)](LICENSE)

一个基于 LazyVim 核心的自治 Neovim 配置，经过完全重构，提供可视化管理、智能推荐和极致性能。

[特性](#特性) • [安装](#安装) • [使用](#使用) • [文档](#文档) • [贡献](#贡献)

</div>

---

## ✨ 特性

### 🎯 核心特性

- **🧩 高度模块化**: 完全模块化的架构，每个功能独立可配置
- **🎨 可视化管理**: 内置图形化界面管理插件和配置
- **🤖 智能推荐**: 基于项目类型和使用习惯的智能配置推荐
- **⚡ 极致性能**: 优化的懒加载和启动速度
- **🔧 灵活配置**: 支持全局、用户、项目级别的分层配置
- **📊 健康监控**: 实时系统健康检查和性能监控
- **🌐 多语言支持**: 中文和英文界面支持

### 🛠️ 功能亮点

#### 编辑增强
- 🔤 智能代码补全 (blink.cmp)
- 🎯 快速跳转 (flash)
- 💬 智能注释 (comment)
- 🔁 自动配对 (autopairs)
- ✨ 符号高亮 (illuminate)

#### 语言支持
- 🔧 LSP 完整支持 (Mason)
- 🎨 代码格式化 (conform)
- 🔍 代码检查 (nvim-lint)
- 🐛 调试支持 (DAP)
- 🌳 语法高亮 (Treesitter)

#### UI 美化
- 📊 状态栏 (lualine)
- 📑 缓冲区管理 (bufferline)
- 🔔 通知系统 (nvim-notify)
- 🎭 命令行增强 (noice)
- 🎨 图标支持 (mini.icons)

#### 文件管理
- 📁 文件浏览器 (neo-tree)
- 🔍 模糊查找 (fzf)
- 🚀 项目管理
- 🔎 搜索替换 (spectre)

#### Git 集成
- 📝 Git 标记 (gitsigns)
- 🎮 Git UI (lazygit)
- 🔄 差异比较

#### 开发工具
- 💻 终端集成 (toggleterm)
- 🧪 测试运行 (neotest)
- 🐞 诊断面板 (trouble)
- 📖 代码大纲 (outline)

#### AI 助手
- 🤖 AI 代码助手 (avante)
- 🎓 GitHub Copilot 支持

---

## 📦 安装

### 系统要求

- **Neovim**: >= 0.9.0
- **Git**: >= 2.19.0
- **Node.js**: >= 18.0.0 (用于某些 LSP 服务器)
- **Python**: >= 3.8 (可选，用于某些插件)
- **Ripgrep**: 用于搜索功能
- **fd**: 用于文件查找

### 基础安装

#### Linux / macOS

```bash
# 备份现有配置（如果有）
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup

# 克隆配置
git clone https://github.com/Genuineh/NvCraft.git ~/.config/nvim

# 启动 Neovim（首次启动会自动安装插件）
nvim
```

#### Windows

```powershell
# 备份现有配置（如果有）
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.backup
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.backup

# 克隆配置
git clone https://github.com/Genuineh/NvCraft.git $env:LOCALAPPDATA\nvim

# 启动 Neovim
nvim
```

### 快速开始

首次启动 Neovim 后，系统会自动：

1. 安装 lazy.nvim 插件管理器
2. 下载和安装所有配置的插件
3. 运行首次配置向导（即将推出）

等待所有插件安装完成后，重启 Neovim 即可开始使用。

---

## 🎮 使用

### 基础快捷键

#### 领导键
- **Leader**: `<Space>`
- **Local Leader**: `<Space>`

#### 文件操作
- `<leader>e` - 打开文件浏览器
- `<leader>ff` - 查找文件
- `<leader>fg` - 全局搜索
- `<leader>fb` - 浏览缓冲区

#### 窗口管理
- `<leader>sv` - 垂直分割
- `<leader>sh` - 水平分割
- `<leader>h/j/k/l` - 窗口导航

#### 编辑操作
- `<leader>s` - 保存文件
- `<leader>q` - 关闭窗口
- `<leader>nh` - 清除高亮
- `jk` - 退出插入模式（在插入模式下）

#### Git 操作
- `<leader>gg` - 打开 lazygit
- `<leader>eg` - Git 状态浏览器

#### 代码操作
- `gd` - 跳转到定义
- `gr` - 查找引用
- `K` - 显示悬停文档
- `<leader>ca` - 代码操作

#### 其他
- `<leader>?` - 显示快捷键帮助

*更多快捷键请使用 `<leader>?` 查看*

---

## 📚 文档

### 用户文档
- [快速开始指南](docs/user/quickstart.md) - 快速上手指南
- [配置指南](docs/user/configuration.md) - 详细配置说明
- [模块管理](docs/user/modules.md) - 模块使用和管理
- [可视化管理](docs/user/visual-management.md) - UI 管理界面使用
- [常见问题](docs/user/faq.md) - 常见问题解答
- [故障排除](docs/user/troubleshooting.md) - 问题诊断和解决

### 开发者文档
- [架构设计](docs/architecture/overview.md) - 系统架构说明
- [模块开发](docs/dev/module-development.md) - 如何开发新模块
- [API 参考](docs/api/reference.md) - API 文档
- [贡献指南](CONTRIBUTING.md) - 如何贡献代码

---

## 🗂️ 项目结构

```
NvCraft/
├── init.lua                    # 入口文件
├── lua/
│   ├── core/                   # 核心系统（当前版本）
│   │   ├── init.lua           # 核心初始化
│   │   ├── runtime.lua        # 运行时管理
│   │   ├── settings.lua       # 基础设置
│   │   └── modules/           # 插件模块
│   │       ├── base.lua       # 基础配置
│   │       ├── neotree.lua    # 文件浏览器
│   │       ├── lualine.lua    # 状态栏
│   │       └── ...            # 其他模块
│   ├── utils/                  # 工具函数
│   │   ├── modules.lua        # 模块工具
│   │   ├── plugin.lua         # 插件工具
│   │   └── lsp.lua            # LSP 工具
│   └── nvcraft/               # 新架构（规划中）
│       ├── core/              # 核心系统
│       │   ├── registry.lua   # 模块注册中心
│       │   ├── loader.lua     # 模块加载器
│       │   ├── events.lua     # 事件系统
│       │   └── metadata.lua   # 元数据管理
│       ├── config/            # 配置管理
│       │   ├── manager.lua    # 配置管理器
│       │   └── storage.lua    # 配置存储
│       ├── modules/           # 模块目录
│       │   ├── base/          # 基础模块
│       │   ├── editor/        # 编辑增强
│       │   ├── lsp/           # 语言支持
│       │   ├── ui/            # UI 组件
│       │   ├── files/         # 文件管理
│       │   ├── git/           # Git 集成
│       │   ├── tools/         # 工具集成
│       │   ├── ai/            # AI 助手
│       │   └── specialized/   # 专用工具
│       ├── ui/                # UI 系统
│       │   ├── module_manager.lua  # 模块管理器
│       │   ├── config_editor.lua   # 配置编辑器
│       │   ├── dashboard.lua       # 仪表盘
│       │   └── health.lua          # 健康检查
│       ├── smart/             # 智能化功能
│       │   ├── detector.lua   # 自动检测
│       │   ├── recommender.lua # 智能推荐
│       │   ├── context.lua    # 上下文管理
│       │   └── optimizer.lua  # 自动优化
│       └── dev/               # 开发工具
│           ├── scaffold.lua   # 脚手架
│           └── helpers.lua    # 辅助工具
├── docs/                       # 文档目录
│   ├── user/                  # 用户文档
│   ├── dev/                   # 开发者文档
│   ├── api/                   # API 文档
│   └── architecture/          # 架构文档
├── tests/                      # 测试目录
│   ├── unit/                  # 单元测试
│   └── integration/           # 集成测试
├── examples/                   # 示例目录
│   ├── configs/               # 配置示例
│   └── modules/               # 模块示例
├── TODO.md                     # 开发计划
├── CHANGELOG.md                # 变更日志
├── CONTRIBUTING.md             # 贡献指南
└── README.md                   # 本文件
```

---

## 🔧 配置

### 基础配置

NvCraft 支持多层级配置：

1. **全局配置**: `~/.config/nvim/lua/core/`
2. **用户配置**: `~/.config/nvim/user/`（即将支持）
3. **项目配置**: `.nvcraft/config.lua`（即将支持）

### 自定义模块

要自定义或添加新模块：

1. 在 `lua/core/modules/` 创建新的 Lua 文件
2. 在 `lua/core/init.lua` 的 `_modules` 表中添加模块名
3. 重启 Neovim 或执行 `:Lazy reload`

示例模块结构：

```lua
return {
  "plugin/repository",
  opts = {
    -- 插件配置
  },
  keys = {
    -- 快捷键绑定
  },
  config = function(_, opts)
    -- 初始化代码
  end,
}
```

---

## 🚀 路线图

详细的开发计划请查看 [TODO.md](TODO.md)。

### 近期目标 (v0.1.0 - v0.3.0)
- ✅ 完成项目规划和文档
- 🔄 重构核心模块系统
- 🔄 实现配置管理系统
- 🔄 开发可视化管理界面

### 中期目标 (v0.4.0 - v0.6.0)
- 🔄 实现智能推荐系统
- 🔄 添加性能监控和优化
- 🔄 完善文档和示例

### 长期目标 (v1.0.0+)
- 🔄 社区插件市场
- 🔄 云同步配置
- 🔄 AI 辅助配置

---

## 🤝 贡献

我们欢迎各种形式的贡献！

### 如何贡献

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交你的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

### 贡献指南

- 遵循现有的代码风格
- 为新功能添加测试
- 更新相关文档
- 确保所有测试通过

详细信息请查看 [贡献指南](CONTRIBUTING.md)。

---

## 📊 性能

NvCraft 注重性能优化：

- **启动时间**: < 100ms（目标）
- **插件加载**: 懒加载优化
- **内存占用**: 优化的资源管理
- **响应速度**: 异步处理优化

---

## 🙏 致谢

NvCraft 基于以下优秀项目：

- [Neovim](https://neovim.io/) - 强大的文本编辑器
- [LazyVim](https://github.com/LazyVim/LazyVim) - 灵感来源
- [lazy.nvim](https://github.com/folke/lazy.nvim) - 插件管理器
- 所有插件作者和贡献者

感谢开源社区的支持！

---

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)。

---

## 📮 联系方式

- **Issues**: [GitHub Issues](https://github.com/Genuineh/NvCraft/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Genuineh/NvCraft/discussions)

---

## ⭐ Star History

如果这个项目对你有帮助，请给我们一个 Star！

---

<div align="center">

**用 ❤️ 和 ☕ 制作**

</div>
