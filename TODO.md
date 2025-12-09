# NvCraft 模块化重构 TODO

## 项目目标

将 NvCraft 从基于 LazyVim 的配置转变为一个高度模块化、智能化、易于维护管理的 Neovim 配置系统，具备可视化管理能力。

---

## 第一阶段：架构设计与规划 ✅

### 1.1 当前状态分析 ✅
- [x] 评估现有代码结构
- [x] 识别模块依赖关系
- [x] 记录现有功能清单
- [x] 分析改进空间

### 1.2 架构设计
- [ ] 设计新的目录结构
- [ ] 定义模块接口标准
- [ ] 设计配置文件格式
- [ ] 规划插件管理系统
- [ ] 设计元数据系统

---

## 第二阶段：核心基础设施

### 2.1 模块系统重构
- [ ] 创建模块注册中心 (`lua/nvcraft/core/registry.lua`)
  - [ ] 模块自动发现机制
  - [ ] 模块依赖解析
  - [ ] 模块生命周期管理
  - [ ] 模块版本控制
  
- [ ] 实现模块加载器 (`lua/nvcraft/core/loader.lua`)
  - [ ] 懒加载优化
  - [ ] 错误处理与恢复
  - [ ] 模块热重载
  - [ ] 加载顺序管理

- [ ] 设计模块元数据 (`lua/nvcraft/core/metadata.lua`)
  - [ ] 模块描述信息
  - [ ] 依赖声明
  - [ ] 配置 Schema
  - [ ] 兼容性标记

### 2.2 配置管理系统
- [ ] 创建配置管理器 (`lua/nvcraft/config/manager.lua`)
  - [ ] 分层配置支持（全局/用户/项目）
  - [ ] 配置验证
  - [ ] 配置迁移工具
  - [ ] 配置导出/导入

- [ ] 实现配置存储 (`lua/nvcraft/config/storage.lua`)
  - [ ] JSON/YAML 格式支持
  - [ ] 配置文件监听
  - [ ] 自动备份机制
  - [ ] 配置版本历史

### 2.3 事件系统
- [ ] 构建事件总线 (`lua/nvcraft/core/events.lua`)
  - [ ] 事件发布订阅
  - [ ] 异步事件处理
  - [ ] 事件优先级
  - [ ] 事件历史记录

---

## 第三阶段：模块重构

### 3.1 模块分类与组织
- [ ] **基础模块** (`lua/nvcraft/modules/base/`)
  - [ ] `core.lua` - 核心设置
  - [ ] `ui.lua` - UI 基础配置
  - [ ] `keymaps.lua` - 按键映射
  - [ ] `autocmds.lua` - 自动命令

- [ ] **编辑增强** (`lua/nvcraft/modules/editor/`)
  - [ ] `completion.lua` - 代码补全 (blink.cmp)
  - [ ] `snippets.lua` - 代码片段
  - [ ] `autopairs.lua` - 自动配对
  - [ ] `comment.lua` - 注释增强
  - [ ] `flash.lua` - 快速跳转
  - [ ] `illuminate.lua` - 符号高亮

- [ ] **语言支持** (`lua/nvcraft/modules/lsp/`)
  - [ ] `mason.lua` - LSP 安装管理
  - [ ] `servers.lua` - LSP 服务器配置
  - [ ] `formatter.lua` - 代码格式化 (conform)
  - [ ] `linter.lua` - 代码检查 (nvim-lint)
  - [ ] `dap.lua` - 调试适配器

- [ ] **UI 组件** (`lua/nvcraft/modules/ui/`)
  - [ ] `statusline.lua` - 状态栏 (lualine)
  - [ ] `bufferline.lua` - 缓冲区行
  - [ ] `notify.lua` - 通知系统
  - [ ] `noice.lua` - 命令行增强
  - [ ] `icons.lua` - 图标系统 (mini.icons)
  - [ ] `colorscheme.lua` - 主题管理

- [ ] **文件管理** (`lua/nvcraft/modules/files/`)
  - [ ] `explorer.lua` - 文件浏览器 (neo-tree)
  - [ ] `fuzzy.lua` - 模糊查找 (fzf)
  - [ ] `project.lua` - 项目管理
  - [ ] `spectre.lua` - 搜索替换

- [ ] **Git 集成** (`lua/nvcraft/modules/git/`)
  - [ ] `signs.lua` - Git 标记 (gitsigns)
  - [ ] `lazygit.lua` - Git UI
  - [ ] `diff.lua` - 差异比较

- [ ] **工具集成** (`lua/nvcraft/modules/tools/`)
  - [ ] `terminal.lua` - 终端集成 (toggleterm)
  - [ ] `testing.lua` - 测试运行 (neotest)
  - [ ] `trouble.lua` - 诊断面板
  - [ ] `outline.lua` - 代码大纲
  - [ ] `markdown.lua` - Markdown 支持
  - [ ] `images.lua` - 图片预览

- [ ] **AI 助手** (`lua/nvcraft/modules/ai/`)
  - [ ] `avante.lua` - AI 代码助手
  - [ ] `copilot.lua` - GitHub Copilot (可选)

- [ ] **专用工具** (`lua/nvcraft/modules/specialized/`)
  - [ ] `flutter.lua` - Flutter 开发
  - [ ] `obsidian.lua` - Obsidian 笔记
  - [ ] 其他语言特定工具

### 3.2 统一模块接口
- [ ] 定义标准模块结构
  ```lua
  return {
    name = "module_name",
    version = "1.0.0",
    description = "模块描述",
    category = "editor", -- base/editor/lsp/ui/files/git/tools/ai/specialized
    dependencies = {},
    
    -- 元数据
    meta = {
      author = "",
      homepage = "",
      tags = {},
      enabled_by_default = true,
    },
    
    -- 配置 Schema
    config_schema = {},
    
    -- 插件定义
    plugins = {},
    
    -- 设置函数
    setup = function(opts) end,
    
    -- 按键绑定
    keys = {},
    
    -- 自动命令
    autocmds = {},
    
    -- 健康检查
    health_check = function() end,
  }
  ```

---

## 第四阶段：可视化管理系统

### 4.1 模块管理界面
- [ ] 创建可视化插件管理器 (`lua/nvcraft/ui/module_manager.lua`)
  - [ ] 模块列表展示
  - [ ] 模块启用/禁用
  - [ ] 模块配置编辑
  - [ ] 模块搜索过滤
  - [ ] 模块依赖可视化

- [ ] 实现配置编辑器 (`lua/nvcraft/ui/config_editor.lua`)
  - [ ] 图形化配置界面
  - [ ] 实时预览
  - [ ] 配置验证提示
  - [ ] 配置模板

### 4.2 仪表盘系统
- [ ] 创建主仪表盘 (`lua/nvcraft/ui/dashboard.lua`)
  - [ ] 启动画面
  - [ ] 快速操作面板
  - [ ] 项目快速访问
  - [ ] 统计信息展示
  - [ ] 健康状态总览

- [ ] 健康检查面板 (`lua/nvcraft/ui/health.lua`)
  - [ ] 系统健康检查
  - [ ] 模块状态监控
  - [ ] 性能分析
  - [ ] 问题诊断

### 4.3 交互式配置向导
- [ ] 首次启动向导 (`lua/nvcraft/ui/wizard.lua`)
  - [ ] 欢迎界面
  - [ ] 基础配置选择
  - [ ] 模块推荐
  - [ ] 主题选择
  - [ ] 按键方案选择

---

## 第五阶段：智能化功能

### 5.1 自动配置
- [ ] 实现自动检测 (`lua/nvcraft/smart/detector.lua`)
  - [ ] 项目类型识别
  - [ ] 语言环境检测
  - [ ] 依赖项检测
  - [ ] 工具链发现

- [ ] 智能推荐系统 (`lua/nvcraft/smart/recommender.lua`)
  - [ ] 基于项目类型推荐插件
  - [ ] 基于使用习惯优化配置
  - [ ] 性能优化建议
  - [ ] 插件冲突检测

### 5.2 上下文感知
- [ ] 创建上下文管理器 (`lua/nvcraft/smart/context.lua`)
  - [ ] 文件类型上下文
  - [ ] 项目上下文
  - [ ] Git 上下文
  - [ ] 工作区上下文

- [ ] 动态配置调整 (`lua/nvcraft/smart/adaptive.lua`)
  - [ ] 基于文件类型调整设置
  - [ ] 基于项目大小优化性能
  - [ ] 自动切换主题
  - [ ] 自适应 LSP 配置

### 5.3 性能优化
- [ ] 实现性能监控 (`lua/nvcraft/smart/profiler.lua`)
  - [ ] 启动时间分析
  - [ ] 插件加载时间追踪
  - [ ] 内存使用监控
  - [ ] 性能报告生成

- [ ] 自动优化器 (`lua/nvcraft/smart/optimizer.lua`)
  - [ ] 懒加载优化
  - [ ] 缓存管理
  - [ ] 资源清理
  - [ ] 配置优化建议

---

## 第六阶段：开发者工具

### 6.1 模块开发工具
- [ ] 创建模块脚手架 (`lua/nvcraft/dev/scaffold.lua`)
  - [ ] 模块模板生成
  - [ ] 配置 Schema 生成
  - [ ] 测试文件生成
  - [ ] 文档生成

- [ ] 开发辅助工具 (`lua/nvcraft/dev/helpers.lua`)
  - [ ] 模块热重载
  - [ ] 调试工具
  - [ ] 日志系统
  - [ ] 错误追踪

### 6.2 测试框架
- [ ] 单元测试支持 (`tests/unit/`)
  - [ ] 核心功能测试
  - [ ] 模块加载测试
  - [ ] 配置管理测试

- [ ] 集成测试 (`tests/integration/`)
  - [ ] 模块交互测试
  - [ ] 配置迁移测试
  - [ ] 性能基准测试

---

## 第七阶段：文档与示例

### 7.1 用户文档
- [ ] 创建 README.md
  - [ ] 项目介绍
  - [ ] 特性列表
  - [ ] 快速开始
  - [ ] 安装指南

- [ ] 用户手册 (`docs/user/`)
  - [ ] 基础配置指南
  - [ ] 模块使用说明
  - [ ] 常见问题解答
  - [ ] 故障排除

- [ ] 可视化管理指南 (`docs/user/visual-management.md`)
  - [ ] 界面操作说明
  - [ ] 配置编辑指南
  - [ ] 模块管理教程

### 7.2 开发者文档
- [ ] API 文档 (`docs/api/`)
  - [ ] 核心 API 参考
  - [ ] 模块开发指南
  - [ ] 插件开发指南
  - [ ] 钩子和事件

- [ ] 架构文档 (`docs/architecture/`)
  - [ ] 系统架构图
  - [ ] 模块设计模式
  - [ ] 数据流说明
  - [ ] 扩展指南

### 7.3 示例与模板
- [ ] 配置示例 (`examples/configs/`)
  - [ ] 最小配置
  - [ ] 完整配置
  - [ ] 语言特定配置
  - [ ] 工作流配置

- [ ] 模块示例 (`examples/modules/`)
  - [ ] 简单模块示例
  - [ ] 复杂模块示例
  - [ ] 自定义 UI 模块

---

## 第八阶段：迁移与兼容

### 8.1 向后兼容
- [ ] 创建兼容层 (`lua/nvcraft/compat/`)
  - [ ] 旧配置格式支持
  - [ ] API 兼容包装
  - [ ] 弃用警告系统

### 8.2 迁移工具
- [ ] 配置迁移脚本 (`lua/nvcraft/migrate/`)
  - [ ] 自动配置转换
  - [ ] 配置验证
  - [ ] 迁移报告生成

- [ ] 迁移指南 (`docs/migration.md`)
  - [ ] 从旧版本迁移
  - [ ] 配置对照表
  - [ ] 常见迁移问题

---

## 第九阶段：质量保证

### 9.1 代码质量
- [ ] 添加代码规范检查
  - [ ] Lua 代码风格检查
  - [ ] 静态分析
  - [ ] 类型注解

- [ ] 持续集成 (`.github/workflows/`)
  - [ ] 自动化测试
  - [ ] 代码质量检查
  - [ ] 文档构建

### 9.2 性能测试
- [ ] 启动性能基准
- [ ] 内存使用测试
- [ ] 插件加载时间测试
- [ ] 性能回归测试

### 9.3 用户测试
- [ ] Beta 测试计划
- [ ] 收集用户反馈
- [ ] 问题追踪和修复

---

## 第十阶段：发布与维护

### 10.1 版本发布
- [ ] 版本号规范
- [ ] 变更日志 (CHANGELOG.md)
- [ ] 发布说明
- [ ] 标签和发行版

### 10.2 社区建设
- [ ] 贡献指南 (CONTRIBUTING.md)
- [ ] 行为准则 (CODE_OF_CONDUCT.md)
- [ ] Issue 模板
- [ ] PR 模板

### 10.3 持续维护
- [ ] 定期更新依赖
- [ ] 性能优化
- [ ] Bug 修复
- [ ] 功能增强

---

## 技术债务与优化

### 待解决问题
- [ ] 移除硬编码路径 (`lua/core/settings.lua`)
- [ ] 统一错误处理机制
- [ ] 改进日志系统
- [ ] 优化启动性能
- [ ] 减少插件冲突

### 性能优化点
- [ ] 实现更智能的懒加载
- [ ] 优化模块依赖解析
- [ ] 缓存常用配置
- [ ] 减少不必要的自动命令
- [ ] 优化文件监听

---

## 关键特性清单

### 核心特性
- ✅ 基于 LazyVim 的核心
- [ ] 高度模块化架构
- [ ] 可视化管理界面
- [ ] 智能配置推荐
- [ ] 动态上下文感知
- [ ] 性能监控优化
- [ ] 一键配置导入导出

### 用户体验
- [ ] 直观的 UI 界面
- [ ] 交互式配置向导
- [ ] 实时配置预览
- [ ] 智能错误提示
- [ ] 快捷操作面板
- [ ] 多语言支持（中/英）

### 开发者友好
- [ ] 清晰的 API 文档
- [ ] 完善的开发工具
- [ ] 模块热重载
- [ ] 丰富的示例
- [ ] 类型提示支持

---

## 项目里程碑

### Milestone 1: 基础架构 (v0.1.0)
- 完成核心模块系统重构
- 实现基础配置管理
- 建立事件系统

### Milestone 2: 模块迁移 (v0.2.0)
- 完成所有现有模块重构
- 统一模块接口
- 添加模块元数据

### Milestone 3: 可视化界面 (v0.3.0)
- 实现模块管理器 UI
- 创建配置编辑器
- 添加仪表盘

### Milestone 4: 智能化 (v0.4.0)
- 实现自动配置
- 添加智能推荐
- 性能优化

### Milestone 5: 文档完善 (v0.5.0)
- 完成用户文档
- 完成开发者文档
- 添加示例和教程

### Milestone 6: 正式发布 (v1.0.0)
- 完整功能测试
- 性能优化
- 社区准备

---

## 技术栈

### 核心技术
- **Neovim**: 0.9.0+
- **Lua**: 5.1+
- **lazy.nvim**: 插件管理器

### 依赖工具
- **Mason**: LSP/DAP/Linter 安装
- **Telescope/FZF**: 模糊查找
- **Treesitter**: 语法高亮
- **LSP**: 语言服务器协议

### UI 框架
- **nui.nvim**: UI 组件库
- **plenary.nvim**: Lua 工具函数
- **mini.icons**: 图标系统

---

## 设计原则

1. **模块化优先**: 每个功能独立模块，松耦合设计
2. **性能至上**: 懒加载、异步处理、缓存优化
3. **用户友好**: 直观的界面、清晰的提示、简单的操作
4. **开发者友好**: 清晰的 API、完善的文档、丰富的示例
5. **可扩展性**: 易于添加新模块、自定义配置
6. **向后兼容**: 平滑升级、配置迁移工具
7. **智能化**: 自动检测、智能推荐、上下文感知
8. **可维护性**: 代码规范、测试覆盖、文档完整

---

## 预期成果

完成后的 NvCraft 将具备：

1. **清晰的架构**: 模块化设计，职责明确
2. **强大的功能**: 完整的开发工具链集成
3. **优秀的性能**: 快速启动，流畅运行
4. **直观的管理**: 可视化配置和模块管理
5. **智能的助手**: 自动配置和智能推荐
6. **完善的文档**: 用户和开发者文档齐全
7. **活跃的社区**: 易于贡献和扩展

---

## 注意事项

1. 保持向后兼容性，提供迁移工具
2. 注重性能优化，避免过度抽象
3. 保持代码简洁，避免过度工程化
4. 及时更新文档，与代码保持同步
5. 收集用户反馈，持续改进
6. 定期进行性能测试和优化
7. 遵循 Neovim 最佳实践

---

## 参考资源

- [Neovim 官方文档](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [LazyVim](https://github.com/LazyVim/LazyVim)
- [nvim-lua-guide](https://github.com/nanotee/nvim-lua-guide)
- [awesome-neovim](https://github.com/rockerBOO/awesome-neovim)

---

**最后更新**: 2025-12-09
**项目状态**: 规划阶段
**当前版本**: 0.0.1
**目标版本**: 1.0.0
