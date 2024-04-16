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
    enabled = not vim.g.basic,
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
    "mickael-menu/zk-nvim",
    enabled = not vim.g.basic,
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
    enabled = not vim.g.basic,
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
    enabled = not vim.g.basic,
    cmd = { "Trouble" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = true,
    enabled = not vim.g.basic,
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
    enabled = not vim.g.basic,
    config = function()
      vim.g.jupytext_fmt = "py:percent"
    end,
  },
}
