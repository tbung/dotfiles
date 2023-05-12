return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "hkupty/iron.nvim",
    keys = {
      "<leader>sc",
      { "<leader>sc", mode = "v" },
      "<leader>sf",
      "<leader>sl",
    },
    config = function()
      local iron = require("iron.core")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { "zsh" },
            },
          },
          repl_open_cmd = require("iron.view").split.vertical(),
        },
        keymaps = {
          send_motion = "<leader>sc",
          visual_send = "<leader>sc",
          send_file = "<leader>sf",
          send_line = "<leader>sl",
          -- cr = "<space>s<cr>",
          interrupt = "<leader>s<space>",
          exit = "<leader>sq",
          -- clear = "<space>cl",
        },
        -- highlight = {
        --   bg = require("catppuccin.palettes").get_palette().surface0,
        -- },
      })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>tf",
        function()
          require("harpoon.term").gotoTerminal(1)
        end,
      },
      {
        "<leader>td",
        function()
          require("harpoon.term").gotoTerminal(2)
        end,
      },
      {
        "<leader>tg",
        function()
          require("harpoon.term").gotoTerminal(3)
        end,
      },
    },
    opts = {
      global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = true,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "mickael-menu/zk-nvim",
    name = "zk",
    config = true,
    keys = {
      { "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>" },
      { "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>" },
      { "<leader>zt", "<Cmd>ZkTags<CR>" },
      { "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>" },
    },
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>vrn",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
      },
    },
    dependencies = "neovim/nvim-lspconfig",
    config = true,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },

  {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    keys = {
      {
        "-",
        function()
          require("oil").open()
        end,
        desc = "Open parent directory",
      },
    },
    config = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
