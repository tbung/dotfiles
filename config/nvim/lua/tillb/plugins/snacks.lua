vim.pack.add({ "https://github.com/folke/snacks.nvim" })

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
