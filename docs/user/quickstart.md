# 快速开始指南

欢迎使用 NvCraft！本指南将帮助你快速上手。

## 安装

### 前置要求

在安装 NvCraft 之前，请确保你的系统已安装以下工具：

#### 必需
- **Neovim** >= 0.9.0
  ```bash
  nvim --version
  ```
- **Git** >= 2.19.0
  ```bash
  git --version
  ```

#### 推荐
- **Node.js** >= 18.0 (用于某些 LSP 服务器)
- **Python** >= 3.8 (用于某些插件)
- **Ripgrep** (用于文本搜索)
  ```bash
  # Ubuntu/Debian
  sudo apt install ripgrep
  
  # macOS
  brew install ripgrep
  
  # Arch Linux
  sudo pacman -S ripgrep
  ```
- **fd** (用于文件查找)
  ```bash
  # Ubuntu/Debian
  sudo apt install fd-find
  
  # macOS
  brew install fd
  
  # Arch Linux
  sudo pacman -S fd
  ```

### 安装步骤

#### 1. 备份现有配置

```bash
# Linux/macOS
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup

# Windows (PowerShell)
Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.backup
Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.backup
```

#### 2. 克隆 NvCraft

```bash
# Linux/macOS
git clone https://github.com/Genuineh/NvCraft.git ~/.config/nvim

# Windows (PowerShell)
git clone https://github.com/Genuineh/NvCraft.git $env:LOCALAPPDATA\nvim
```

#### 3. 启动 Neovim

```bash
nvim
```

首次启动时，NvCraft 会自动：
1. 安装 lazy.nvim 插件管理器
2. 下载所有配置的插件
3. 设置语言服务器

这个过程可能需要几分钟，请耐心等待。

#### 4. 重启 Neovim

插件安装完成后，退出并重新启动 Neovim：
```bash
:q
nvim
```

---

## 基础使用

### 领导键

NvCraft 的领导键（Leader Key）设置为 **空格键** (`<Space>`)。

大多数快捷键都以领导键开头，例如 `<leader>e` 表示先按空格，再按 `e`。

### 常用快捷键

#### 文件操作
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<leader>e` | 打开文件浏览器 | 显示 neo-tree 文件浏览器 |
| `<leader>s` | 保存文件 | 保存当前文件 |
| `<leader>q` | 关闭窗口 | 关闭当前窗口 |

#### 查找
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<leader>ff` | 查找文件 | 模糊查找文件 |
| `<leader>fg` | 全局搜索 | 在项目中搜索文本 |
| `<leader>fb` | 浏览缓冲区 | 在打开的缓冲区中查找 |
| `<leader>nh` | 清除高亮 | 清除搜索高亮 |

#### 窗口管理
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<leader>sv` | 垂直分割 | 垂直分割窗口 |
| `<leader>sh` | 水平分割 | 水平分割窗口 |
| `<leader>h` | 跳转左窗口 | 移动到左边窗口 |
| `<leader>l` | 跳转右窗口 | 移动到右边窗口 |
| `<leader>j` | 跳转下窗口 | 移动到下方窗口 |
| `<leader>k` | 跳转上窗口 | 移动到上方窗口 |

#### 编辑
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `jk` | 退出插入模式 | 在插入模式下按 `jk` 返回普通模式 |
| `J` (可视模式) | 下移行 | 选中的行下移 |
| `K` (可视模式) | 上移行 | 选中的行上移 |

#### Git
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<leader>gg` | 打开 LazyGit | 打开 Git UI |
| `<leader>eg` | Git 状态 | 显示 Git 状态浏览器 |

#### 帮助
| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `<leader>?` | 快捷键帮助 | 显示所有快捷键 |

---

## 基础配置

### 编辑器设置

NvCraft 的核心设置位于 `lua/core/modules/base.lua`。

主要设置包括：
- **行号**: 相对行号 + 绝对行号
- **缩进**: 4 空格（Dart、JSON、C++ 为 2 空格）
- **光标行**: 高亮当前行
- **剪贴板**: 与系统剪贴板集成
- **搜索**: 智能大小写搜索

### 修改配置

要修改配置：

1. 编辑相应的模块文件：
   ```bash
   nvim ~/.config/nvim/lua/core/modules/base.lua
   ```

2. 保存后重启 Neovim 或执行：
   ```vim
   :source %
   ```

---

## 模块管理

### 启用/禁用模块

在 `lua/core/init.lua` 中的 `_modules` 表控制哪些模块被加载：

```lua
local _modules = {
    "base",
    "neotree",
    "lualine",
    -- 注释掉不需要的模块
    -- "dashboard",
    -- "copilot",
}
```

### 添加新模块

1. 在 `lua/core/modules/` 创建新文件
2. 在 `_modules` 表中添加模块名
3. 重启 Neovim

---

## 语言支持

### 安装 LSP 服务器

NvCraft 使用 Mason 管理 LSP 服务器。

#### 自动安装
某些常用的 LSP 服务器会自动安装。

#### 手动安装
1. 打开 Mason：
   ```vim
   :Mason
   ```

2. 搜索并安装需要的服务器：
   - 使用 `/` 搜索
   - 按 `i` 安装
   - 按 `u` 更新
   - 按 `X` 卸载

#### 常用 LSP 服务器
- **Python**: `pyright`
- **JavaScript/TypeScript**: `typescript-language-server`
- **Lua**: `lua-language-server`
- **Go**: `gopls`
- **Rust**: `rust-analyzer`
- **C/C++**: `clangd`

---

## 主题配置

### 切换主题

编辑 `lua/core/modules/colorshceme.lua` 来更改主题。

### 可用主题
- Catppuccin (默认)
- TokyoNight
- 其他（可在配置文件中添加）

---

## 常见问题

### 1. 插件安装失败

**解决方案**:
- 检查网络连接
- 尝试手动安装：`:Lazy sync`
- 查看日志：`:Lazy log`

### 2. LSP 不工作

**解决方案**:
- 确保安装了相应的 LSP 服务器：`:Mason`
- 检查 LSP 状态：`:LspInfo`
- 重启 LSP：`:LspRestart`

### 3. 图标显示异常

**解决方案**:
- 安装 Nerd Font 字体
- 设置终端使用 Nerd Font

### 4. 性能问题

**解决方案**:
- 禁用不需要的模块
- 减少自动命令
- 查看启动时间：`nvim --startuptime startup.log`

---

## 下一步

- 📖 阅读 [详细文档](../README.md)
- 🔧 学习 [自定义配置](configuration.md)（即将推出）
- 🎨 了解 [模块系统](modules.md)（即将推出）
- 💡 查看 [示例配置](../../examples/)（即将推出）

---

## 获取帮助

遇到问题？

- 📚 查看 [FAQ](faq.md)（即将推出）
- 🐛 报告 [Bug](https://github.com/Genuineh/NvCraft/issues)
- 💬 加入 [讨论](https://github.com/Genuineh/NvCraft/discussions)
- 📝 查看 [文档](../README.md)

---

享受使用 NvCraft！🚀
