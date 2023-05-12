require("tillb.options")
require("tillb.keymap")

return {
  {
    "tpope/vim-fugitive",
    cmd = "G",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      attach_to_untracked = true,
    },
  },
  {
    "tpope/vim-eunuch",
    event = "InsertEnter",
    cmd = {
      "Remove",
      "Move",
      "Rename",
      "Chmod",
      "Mkdir",
      "SudoEdit",
      "SudoWrite",
    },
  },
  {
    "jinh0/eyeliner.nvim",
    keys = { "f", "F", "t", "T" },
    opts = { highlight_on_key = true, dim = true },
  },
  {
    "echasnovski/mini.starter",
    event = "VimEnter",
    config = function()
      local starter = require("mini.starter")
      starter.setup({
        items = {
          starter.sections.recent_files(5, true, false),
          starter.sections.builtin_actions(),
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          starter.config.footer = "Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(starter.refresh)
        end,
      })
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup()
    end,
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    config = function()
      require("mini.comment").setup()
    end,
  },
  {
    "vigoux/notifier.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { mode = "n", "w",  "<cmd>lua require('spider').motion('w')<CR>",  desc = "Spider-w" },
      { mode = "n", "e",  "<cmd>lua require('spider').motion('e')<CR>",  desc = "Spider-e" },
      { mode = "n", "b",  "<cmd>lua require('spider').motion('b')<CR>",  desc = "Spider-b" },
      { mode = "n", "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider-ge" },
      { mode = "o", "w",  "<cmd>lua require('spider').motion('w')<CR>",  desc = "Spider-w" },
      { mode = "o", "e",  "<cmd>lua require('spider').motion('e')<CR>",  desc = "Spider-e" },
      { mode = "o", "b",  "<cmd>lua require('spider').motion('b')<CR>",  desc = "Spider-b" },
      { mode = "o", "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider-ge" },
      { mode = "x", "w",  "<cmd>lua require('spider').motion('w')<CR>",  desc = "Spider-w" },
      { mode = "x", "e",  "<cmd>lua require('spider').motion('e')<CR>",  desc = "Spider-e" },
      { mode = "x", "b",  "<cmd>lua require('spider').motion('b')<CR>",  desc = "Spider-b" },
      { mode = "x", "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider-ge" },
    },
  },
}
