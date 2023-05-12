return {
  "mbbill/undotree",
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      attach_to_untracked = true,
    },
  },
  "tpope/vim-eunuch",
  {
    "numToStr/Comment.nvim",
    config = true,
  },
  {
    "jinh0/eyeliner.nvim",
    opts = { highlight_on_key = true, dim = true },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = true,
  },
  {
    "hkupty/iron.nvim",
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
        highlight = {
          bg = require("catppuccin.palettes").get_palette().surface0,
        },
      })
    end,
  },

  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.starter").setup({
        items = {
          require("mini.starter").sections.recent_files(5, true, false),
          require("mini.starter").sections.builtin_actions(),
        },
      })

      require("mini.ai").setup()
      require("mini.surround").setup()
    end,
  },

  "nvim-tree/nvim-web-devicons",

  {
    "vigoux/notifier.nvim",
    config = true,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
  },

  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({
        global_settings = {
          save_on_toggle = false,
          save_on_change = true,
          enter_on_sendcmd = true,
          tmux_autoclose_windows = false,
          excluded_filetypes = { "harpoon" },
        },
      })

      vim.keymap.set("n", "<leader>tf", function()
        require("harpoon.term").gotoTerminal(1)
      end, {})
      vim.keymap.set("n", "<leader>td", function()
        require("harpoon.term").gotoTerminal(2)
      end, {})
      vim.keymap.set("n", "<leader>tg", function()
        require("harpoon.term").gotoTerminal(3)
      end, {})
    end,
  },

  {
    "folke/which-key.nvim",
    config = true,
  },

  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
  },

  "folke/neodev.nvim",

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
    config = true,
  },

  {
    "chrisgrieser/nvim-spider",
    config = function()
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
    end,
  },
  "sindrets/diffview.nvim",

  {
    "stevearc/oil.nvim",
    config = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}
