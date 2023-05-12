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
      require("mini.starter").setup({
        items = {
          require("mini.starter").sections.recent_files(5, true, false),
          require("mini.starter").sections.builtin_actions(),
        },
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
      { "n", "w",  "<cmd>lua require('spider').motion('w')<CR>",  desc = "Spider-w" },
      { "n", "e",  "<cmd>lua require('spider').motion('e')<CR>",  desc = "Spider-e" },
      { "n", "b",  "<cmd>lua require('spider').motion('b')<CR>",  desc = "Spider-b" },
      { "n", "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider-ge" },
      { "o", "w",  "<cmd>lua require('spider').motion('w')<CR>",  desc = "Spider-w" },
      { "o", "e",  "<cmd>lua require('spider').motion('e')<CR>",  desc = "Spider-e" },
      { "o", "b",  "<cmd>lua require('spider').motion('b')<CR>",  desc = "Spider-b" },
      { "o", "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider-ge" },
      { "x", "w",  "<cmd>lua require('spider').motion('w')<CR>",  desc = "Spider-w" },
      { "x", "e",  "<cmd>lua require('spider').motion('e')<CR>",  desc = "Spider-e" },
      { "x", "b",  "<cmd>lua require('spider').motion('b')<CR>",  desc = "Spider-b" },
      { "x", "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider-ge" },
    },
  },
}
