# 贡献指南

感谢你考虑为 NvCraft 做出贡献！这个文档提供了贡献的指南和最佳实践。

## 行为准则

参与本项目即表示你同意遵守我们的行为准则。请友善、尊重和包容。

## 如何贡献

### 报告 Bug

如果你发现了 Bug，请：

1. 检查 [Issues](https://github.com/Genuineh/NvCraft/issues) 是否已有相同问题
2. 如果没有，创建新的 Issue，包含：
   - 清晰的标题和描述
   - 复现步骤
   - 预期行为和实际行为
   - Neovim 版本、操作系统等环境信息
   - 相关的日志或错误信息
   - 截图（如果适用）

### 建议新功能

我们欢迎新功能建议！请：

1. 检查 [Issues](https://github.com/Genuineh/NvCraft/issues) 和 [TODO.md](TODO.md) 确认功能未被计划
2. 创建一个 Feature Request Issue，说明：
   - 功能描述
   - 使用场景
   - 为什么这个功能有用
   - 可能的实现方案（可选）

### 提交代码

#### 准备工作

1. Fork 本仓库
2. 克隆你的 fork：
   ```bash
   git clone https://github.com/你的用户名/NvCraft.git
   cd NvCraft
   ```
3. 添加上游仓库：
   ```bash
   git remote add upstream https://github.com/Genuineh/NvCraft.git
   ```

#### 开发流程

1. 创建新分支：
   ```bash
   git checkout -b feature/你的功能名
   # 或
   git checkout -b fix/bug描述
   ```

2. 进行开发：
   - 遵循代码风格指南（见下文）
   - 添加必要的测试
   - 更新相关文档
   - 确保代码可以正常运行

3. 提交更改：
   ```bash
   git add .
   git commit -m "type: 简短描述"
   ```

   提交信息格式：
   - `feat:` - 新功能
   - `fix:` - Bug 修复
   - `docs:` - 文档更新
   - `style:` - 代码格式调整
   - `refactor:` - 代码重构
   - `perf:` - 性能优化
   - `test:` - 测试相关
   - `chore:` - 构建/工具相关

4. 保持同步：
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

5. 推送到你的 fork：
   ```bash
   git push origin feature/你的功能名
   ```

6. 创建 Pull Request：
   - 访问你的 fork 页面
   - 点击 "New Pull Request"
   - 填写 PR 模板
   - 等待审查

#### Pull Request 指南

一个好的 Pull Request 应该：

- 有清晰的标题和描述
- 关联相关的 Issue
- 包含必要的测试
- 更新相关文档
- 保持提交历史清晰
- 通过所有 CI 检查

### 代码风格

#### Lua 代码规范

- 使用 4 个空格缩进（不是 Tab）
- 变量名使用 snake_case
- 函数名使用 snake_case
- 常量使用 UPPER_CASE
- 每行不超过 120 字符

示例：

```lua
-- 好的写法
local function calculate_sum(numbers)
    local total = 0
    for _, num in ipairs(numbers) do
        total = total + num
    end
    return total
end

local MAX_RETRIES = 3
local user_config = {}

-- 不好的写法
local function calculateSum(Numbers)  -- 应使用 snake_case
  local Total=0  -- 缺少空格
  for _,Num in ipairs(Numbers) do  -- 缺少空格
    Total=Total+Num
  end
  return Total
end
```

#### 模块结构

新模块应遵循以下结构：

```lua
-- lua/nvcraft/modules/category/module_name.lua

return {
    -- 插件名称
    "author/plugin-name",
    
    -- 版本或分支（可选）
    version = "1.0.0",
    -- 或
    branch = "main",
    
    -- 依赖（可选）
    dependencies = {
        "other/plugin",
    },
    
    -- 事件触发（可选）
    event = "VeryLazy",
    -- 或
    cmd = "CommandName",
    -- 或
    keys = { "<leader>x" },
    
    -- 配置选项
    opts = {
        -- 插件配置
    },
    
    -- 配置函数（可选）
    config = function(_, opts)
        require("plugin-name").setup(opts)
    end,
    
    -- 初始化函数（可选）
    init = function()
        -- 在插件加载前执行
    end,
}
```

#### 注释规范

- 使用中文注释（与用户群体一致）
- 复杂逻辑必须添加注释
- 公共 API 必须有文档注释
- 注释应该说明"为什么"而不仅是"是什么"

```lua
-- 好的注释：说明原因和上下文
-- 使用延迟加载避免影响启动速度
-- 参考：https://github.com/folke/lazy.nvim#-installation
vim.opt.rtp:prepend(lazypath)

-- 不够好的注释：仅描述代码做了什么
-- 将 lazypath 添加到 runtimepath
vim.opt.rtp:prepend(lazypath)
```

### 文档

#### 更新文档

如果你的更改影响到用户使用：

1. 更新 README.md
2. 更新相关的 docs/ 文件
3. 添加示例（如果适用）
4. 更新 CHANGELOG.md

#### 文档风格

- 使用清晰、简洁的语言
- 提供代码示例
- 包含截图（UI 更改）
- 使用 Markdown 格式

### 测试

#### 运行测试

```bash
# 运行所有测试
make test

# 运行特定测试
make test-unit
make test-integration
```

#### 编写测试

- 为新功能添加测试
- 为 Bug 修复添加回归测试
- 使用描述性的测试名称
- 测试应该独立且可重复

示例：

```lua
-- tests/unit/config_spec.lua
describe("config manager", function()
    local manager = require("nvcraft.config.manager")
    
    it("should load default config", function()
        local config = manager.load()
        assert.is_not_nil(config)
        assert.equals("default", config.profile)
    end)
    
    it("should validate config schema", function()
        local valid_config = { profile = "user" }
        assert.is_true(manager.validate(valid_config))
    end)
end)
```

## 开发环境设置

### 必需工具

- Neovim >= 0.9.0
- Git
- Lua 5.1+ (通常随 Neovim 提供)
- Node.js (用于某些 LSP)

### 推荐工具

- [stylua](https://github.com/JohnnyMorganz/StyLua) - Lua 代码格式化
- [luacheck](https://github.com/lunarmodules/luacheck) - Lua 静态分析
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - 测试框架

### 设置开发环境

1. 安装推荐工具：
   ```bash
   # stylua
   cargo install stylua
   
   # luacheck
   luarocks install luacheck
   ```

2. 配置 Git hooks（可选）：
   ```bash
   # 在提交前自动格式化代码
   cp .githooks/pre-commit .git/hooks/
   chmod +x .git/hooks/pre-commit
   ```

3. 在测试环境中运行：
   ```bash
   # 使用独立的数据目录测试
   NVIM_APPNAME=nvcraft-test nvim
   ```

## 项目结构说明

### 核心目录

- `lua/core/` - 当前核心系统
- `lua/nvcraft/` - 新架构（开发中）
- `lua/utils/` - 工具函数
- `docs/` - 文档
- `tests/` - 测试文件
- `examples/` - 示例代码

### 命名约定

- 文件名：使用 snake_case
- 目录名：使用 snake_case
- 模块名：遵循 Lua 模块命名
- 配置文件：使用小写字母

## 发布流程

### 版本号规范

遵循语义化版本 (Semantic Versioning)：

- MAJOR.MINOR.PATCH
- MAJOR: 不兼容的 API 更改
- MINOR: 向后兼容的新功能
- PATCH: 向后兼容的 Bug 修复

### 发布检查清单

- [ ] 所有测试通过
- [ ] 文档已更新
- [ ] CHANGELOG.md 已更新
- [ ] 版本号已更新
- [ ] 创建 Git 标签
- [ ] 发布说明已准备

## 获取帮助

如有疑问：

1. 查看 [文档](docs/)
2. 搜索 [Issues](https://github.com/Genuineh/NvCraft/issues)
3. 在 [Discussions](https://github.com/Genuineh/NvCraft/discussions) 提问
4. 查看 [TODO.md](TODO.md) 了解项目方向

## 认可贡献者

所有贡献者都会在 README.md 中得到认可。

---

再次感谢你的贡献！每一个贡献，无论大小，都让 NvCraft 变得更好。

## 参考资源

- [Neovim 官方文档](https://neovim.io/doc/)
- [Lua 编程指南](https://www.lua.org/manual/5.1/)
- [lazy.nvim 文档](https://github.com/folke/lazy.nvim)
- [如何写好 Git 提交信息](https://cbea.ms/git-commit/)
