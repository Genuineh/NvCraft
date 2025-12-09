-- return {
--     {
--         "folke/persistence.nvim",
--         -- event = "BufReadPre", -- this will only start session saving when an actual file was opened
--         opts = { options = vim.opt.sessionoptions:get() },
--         config = function(_, opts)
--             local args = vim.api.nvim_get_vvar("argv")
--             if #args > 2 then
--             else
--                 require("persistence").setup(opts)
--                 require("persistence").load({ last = true })
--             end
--         end,
--     },
-- }
return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
        { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
        { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
        { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
}
