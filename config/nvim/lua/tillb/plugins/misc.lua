vim.pack.add({
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/jinh0/eyeliner.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/echasnovski/mini.surround",
  "https://github.com/chentoast/marks.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/jpalardy/vim-slime",
})

vim.schedule(function()
  require("eyeliner").setup({ highlight_on_key = true, dim = true })
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

vim.g.slime_target = "tmux"
vim.g.slime_default_config = { pane_direction = "right" }
vim.g.slime_no_mappings = 1
vim.g.slime_bracketed_paste = 1

vim.keymap.set("v", "<leader>sc", "<Plug>SlimeRegionSend")
vim.keymap.set("n", "<leader>sc", "<Plug>SlimeMotionSend")
vim.keymap.set("n", "<leader>sl", "<Plug>SlimeLineSend")
