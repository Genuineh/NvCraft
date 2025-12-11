local roots = { "", "", "" }

local toggle = function(num)
  local root = require("nvcraft.core.runtime").root
  local t = require("toggleterm")
  if roots[num] ~= root and roots[num] ~= "" then
    t.exec("cd " .. root, num)
  end
  t.toggle(num, nil, root)
  roots[num] = root
end

return {
  name = "terminal",
  version = "1.0.0",
  description = "Integrated terminal using toggleterm.nvim.",
  category = "tools",
  dependencies = {},
  meta = {
    author = "NvCraft",
    homepage = "https://github.com/NvCraft/NvCraft",
    tags = { "terminal", "toggleterm" },
    enabled_by_default = true,
  },
  config_schema = {},
  plugins = {
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("toggleterm").setup({
          start_in_insert = true,
        })
      end,
    },
  },
  keys = {
    { mode = { "t" }, "<Esc>", "<c-\\><c-n>" },
    { mode = { "t" }, "jk", "<c-\\><c-n>" },
    { mode = { "t" }, "<c-h>", "<cmd>wincmd h<cr>" },
    { mode = { "t" }, "<c-l>", "<cmd>wincmd l<cr>" },
    { mode = { "t" }, "<c-j>", "<cmd>wincmd j<cr>" },
    { mode = { "t" }, "<c-k>", "<cmd>wincmd k<cr>" },
    { mode = { "t" }, "<c-w>", "<c-\\><c-n><c-w>" },
    -- { mode = { "n", "t" }, "<c-`>", "<cmd>exe v:count1 . 'ToggleTerm'<CR>" },
    {
      mode = { "n", "t" },
      "<c-`>",
      function()
        toggle(1)
      end,
    },
    {
      mode = { "n", "t" },
      "<c-1>",
      function()
        toggle(2)
      end,
    },
    {
      mode = { "n", "t" },
      "<c-2>",
      function()
        toggle(3)
      end,
    },
  },
}
