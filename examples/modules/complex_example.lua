-- 复杂模块示例
-- 演示包含快捷键、自动命令和依赖的完整模块

return {
    -- 主插件
    "nvim-neo-tree/neo-tree.nvim",
    
    -- 分支
    branch = "v3.x",
    
    -- 依赖项
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    
    -- 命令触发懒加载
    cmd = "Neotree",
    
    -- 快捷键配置
    keys = {
        {
            "<leader>e",
            function()
                require("neo-tree.command").execute({ toggle = true })
            end,
            desc = "切换文件浏览器"
        },
        {
            "<leader>eg",
            function()
                require("neo-tree.command").execute({ source = "git_status", toggle = true })
            end,
            desc = "Git 状态浏览"
        },
    },
    
    -- 配置选项
    opts = {
        filesystem = {
            follow_current_file = {
                enabled = true,
            },
            use_libuv_file_watcher = true,
        },
        window = {
            position = "left",
            width = 40,
        },
    },
    
    -- 配置函数
    config = function(_, opts)
        require("neo-tree").setup(opts)
        
        -- 添加自动命令
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
            callback = function()
                local stats = vim.uv.fs_stat(vim.fn.argv(0))
                if stats and stats.type == "directory" then
                    require("neo-tree")
                end
            end,
        })
    end,
}

--[[
这个示例展示了：
1. 完整的插件配置
2. 多个依赖项
3. 快捷键绑定
4. 配置函数中的自动命令
5. 条件加载逻辑

这种结构适合需要复杂配置的插件。
--]]
