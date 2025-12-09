# 更新日志 / Changelog

所有值得注意的项目更改都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
项目遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [未发布] - Unreleased

### 规划中 (Planned)
- 模块注册中心和自动发现机制
- 可视化模块管理界面
- 配置管理系统（支持多层级配置）
- 智能推荐系统（基于项目类型）
- 性能监控和优化系统
- 健康检查面板
- 交互式配置向导
- 模块热重载功能
- 配置导出/导入工具
- 多语言界面支持

### 进行中 (In Progress)
- 项目架构重构
- 模块化系统设计
- 文档框架搭建

## [0.0.1] - 2025-12-09

### 新增 (Added)
- ✨ 创建项目基础架构
- 📝 添加完整的 TODO.md 开发计划文档
- 📖 添加 README.md 项目说明文档
- 🤝 添加 CONTRIBUTING.md 贡献指南
- 📋 添加 CHANGELOG.md 更新日志
- 🎯 定义项目目标和核心特性
- 📐 规划 10 个开发阶段的详细计划
- 🗂️ 设计新的目录结构
- 📊 制定项目里程碑

### 当前功能 (Current Features)
基于 LazyVim 核心的完整配置，包含：

#### 编辑器增强
- 智能代码补全 (blink.cmp)
- 快速跳转和导航 (flash)
- 智能注释系统 (comment)
- 自动括号配对 (autopairs)
- 符号高亮显示 (vim-illuminate)

#### 语言支持
- LSP 服务器管理 (Mason)
- 代码格式化 (conform.nvim)
- 代码检查 (nvim-lint)
- 调试适配器协议 (DAP)
- 语法高亮 (nvim-treesitter)

#### 用户界面
- 状态栏 (lualine.nvim)
- 缓冲区标签栏 (bufferline.nvim)
- 通知系统 (nvim-notify)
- 命令行增强 (noice.nvim)
- 图标支持 (mini.icons)
- 配色方案管理
- 光标效果 (smear-cursor)

#### 文件管理
- 文件浏览器 (neo-tree.nvim)
- 模糊查找 (fzf-lua)
- 项目管理
- 搜索和替换 (nvim-spectre)

#### Git 集成
- Git 变更标记 (gitsigns.nvim)
- Git UI 工具 (lazygit.nvim)

#### 开发工具
- 终端集成 (toggleterm.nvim)
- 测试运行器 (neotest)
- 诊断面板 (trouble.nvim)
- 代码大纲 (aerial.nvim / outline.nvim)
- Markdown 预览
- 图片预览支持
- 窗口管理 (edgy.nvim)

#### AI 辅助
- AI 代码助手 (avante.nvim)
- Copilot 支持（可选）

#### 其他功能
- 会话管理 (persistence.nvim)
- 快捷键提示 (which-key.nvim)
- 多种 UI 组件 (snacks.nvim)
- Obsidian 笔记集成
- Flutter 开发工具
- 代码展示工具 (headlines.nvim)

### 技术栈
- Neovim 0.9.0+
- lazy.nvim 插件管理器
- Lua 5.1+ 配置语言

---

## 版本说明

### 版本号格式
- **主版本号 (MAJOR)**: 不兼容的 API 更改
- **次版本号 (MINOR)**: 向后兼容的新功能
- **修订号 (PATCH)**: 向后兼容的问题修复

### 更改类型
- **新增 (Added)**: 新功能
- **更改 (Changed)**: 现有功能的更改
- **弃用 (Deprecated)**: 即将移除的功能
- **移除 (Removed)**: 已移除的功能
- **修复 (Fixed)**: Bug 修复
- **安全 (Security)**: 安全相关更新

---

## 里程碑计划

### v0.1.0 - 基础架构 (预计 2025-Q1)
- [ ] 完成核心模块系统重构
- [ ] 实现基础配置管理
- [ ] 建立事件系统
- [ ] 创建模块加载器

### v0.2.0 - 模块迁移 (预计 2025-Q1)
- [ ] 完成所有现有模块重构
- [ ] 统一模块接口
- [ ] 添加模块元数据系统
- [ ] 实现模块依赖管理

### v0.3.0 - 可视化界面 (预计 2025-Q2)
- [ ] 实现模块管理器 UI
- [ ] 创建配置编辑器
- [ ] 添加交互式仪表盘
- [ ] 实现健康检查面板

### v0.4.0 - 智能化功能 (预计 2025-Q2)
- [ ] 实现自动配置系统
- [ ] 添加智能推荐功能
- [ ] 实现上下文感知
- [ ] 性能监控和优化

### v0.5.0 - 文档完善 (预计 2025-Q3)
- [ ] 完成用户文档
- [ ] 完成开发者文档
- [ ] 添加使用示例
- [ ] 创建视频教程

### v1.0.0 - 正式发布 (预计 2025-Q3)
- [ ] 完整功能测试
- [ ] 性能优化完成
- [ ] 文档完整
- [ ] 社区准备就绪

---

## 贡献者

感谢所有贡献者的努力！

### 核心开发者
- [@Genuineh](https://github.com/Genuineh) - 项目创建者和维护者

### 贡献者列表
*等待第一个贡献者...*

---

## 特别感谢

- [LazyVim](https://github.com/LazyVim/LazyVim) - 灵感来源
- [Neovim](https://neovim.io/) - 强大的编辑器
- [lazy.nvim](https://github.com/folke/lazy.nvim) - 优秀的插件管理器
- 所有插件作者和开源社区

---

## 链接

- [项目主页](https://github.com/Genuineh/NvCraft)
- [问题追踪](https://github.com/Genuineh/NvCraft/issues)
- [讨论区](https://github.com/Genuineh/NvCraft/discussions)
- [文档](docs/)
- [TODO 列表](TODO.md)

---

**注**: 日期格式采用 ISO 8601 (YYYY-MM-DD)
