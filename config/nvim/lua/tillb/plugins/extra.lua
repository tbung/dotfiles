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
  -- TODO: Replace with mini.icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
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
    ft = { "markdown" },
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
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
    config = function()
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
          { "size",  highlight = "Special" },
          { "mtime", highlight = "Number" },
          {
            "icon",
            -- default_file = icon_file,
            -- directory = icon_dir,
            add_padding = true,
          },
        },
      })
    end,
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
}
