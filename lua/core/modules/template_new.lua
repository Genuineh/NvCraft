-- simple puglins
return {
    {
        "url",
        opts = function()
            -- executed during startup
        end,
        key = function()
            -- lazy-load on key
        end,
        config = function()
            -- executed after plugin is loaded
        end,
    },
}

-- return {
-- 	{
-- 		"url like folke/lazy.nvim",
-- 		-- branch
-- 		-- version
-- 		-- tag
-- 		-- commit
-- 		-- lazy = true
-- 		-- enable = true,
-- 		-- init = function()
-- 		-- executed during startup
-- 		-- end
-- 		dependencies = {
-- 			"like tjdevries/colorbuddy.nvim",
-- 		},
-- 		-- or function(LazyPlugin, opts: table)
-- 		opts = {},
-- 		config = function()
-- 			-- executed after plugin is loaded
-- 		end,
-- 		-- event string? or string[] or fun(self:LazyPlugin, event:string[]):string[] or {event:string[]|string, pattern?:string[]|string} Lazy-load on event
-- 		-- cmd = string or function() lazy-load on command
-- 		-- ft = string or function() lazy-load on filetype
-- 		-- key = string or function() lazy-load on key mapping
-- 	},
-- }
