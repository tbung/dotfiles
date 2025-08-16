vim.pack.add({
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/folke/snacks.nvim",
})

vim.schedule(function()
  require("fidget").setup({})
  require("mini.surround").setup({})
end)

local permission_hlgroups = {
  ["-"] = "NonText",
  ["r"] = "DiagnosticSignWarn",
  ["w"] = "DiagnosticSignError",
  ["x"] = "DiagnosticSignOk",
}

require("oil").setup({
  columns = {
    {
      "permissions",
      highlight = function(permission_str)
        local hls = {}
        for i = 1, #permission_str do
          local char = permission_str:sub(i, i)
          table.insert(hls, { permission_hlgroups[char], i - 1, i })
        end
        return hls
      end,
    },
    { "size", highlight = "Special" },
    { "mtime", highlight = "Number" },
    { "icon", add_padding = true },
  },
})

require("snacks").setup({
  bigfile = { enabled = false },
  indent = { enabled = true, scope = { enabled = false }, animate = { enabled = false } },
  input = {
    enabled = true,
    win = {
      keys = {
        i_ctrl_bs = { "<C-BS>", "delete_word", mode = "i", expr = true },
        i_ctrl_h = { "<c-h>", "delete_word", mode = "i", expr = true },
      },
      actions = { delete_word = function()
        return "<c-s-w>"
      end },
    },
  },
  picker = {
    enabled = true,
    win = {
      input = {
        keys = { ["<C-BS>"] = { "<c-s-w>", mode = "i", expr = true }, ["<c-h>"] = { "<c-s-w>", mode = "i", expr = true } },
      },
    },
  },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  words = { enabled = false },
  image = { enabled = false },
})
