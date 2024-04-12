return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      scope = {
        show_start = false,
        show_end = false,
      },
    },
  },
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },
  {
    "jpalardy/vim-slime",
    ft = { "python", "sh" },
    -- lazy = false,
    config = function()
      vim.g.slime_target = "wezterm"
      vim.g.slime_default_config = { pane_direction = "right" }
      vim.g.slime_no_mappings = 1
      vim.g.slime_bracketed_paste = 1

      vim.keymap.set("v", "<leader>sc", "<Plug>SlimeRegionSend")
      vim.keymap.set("n", "<leader>sc", "<Plug>SlimeMotionSend")
      vim.keymap.set("n", "<leader>sl", "<Plug>SlimeLineSend")
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "echasnovski/mini.clue",
    event = "VimEnter",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "x", keys = "'" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },

        window = {
          config = {
            width = "auto",
            border = "none",
          },
        },
      })
    end,
  },

  {
    "mickael-menu/zk-nvim",
    name = "zk",
    config = true,
    keys = {
      {
        "<leader>zn",
        function()
          vim.ui.input({ prompt = "Title: ", default = nil }, function(input)
            if input ~= nil then
              require("zk.commands").get("ZkNew")({ title = input })
            end
          end)
        end,
      },
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
        "<leader>-",
        function()
          require("oil").open()
        end,
        mode = "n",
        desc = "Open parent directory",
      },
    },
    config = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      filetypes = {
        "python",
        "css",
        "scss",
        "javascript",
        html = { mode = "foreground" },
      },
      user_default_options = {
        rgb_fn = true,
      },
    },
  },
  {
    "goerz/jupytext.vim",
    lazy = false,
    config = function()
      vim.g.jupytext_fmt = "py:percent"
    end,
  },
}
