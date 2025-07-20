return {
  {
    "tpope/vim-fugitive",
    cmd = "G",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.nav_hunk("prev")
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.nav_hunk("next")
          end)
          return "<Ignore>"
        end, { expr = true })

        -- Actions
        map("n", "<leader>gs", gs.stage_hunk)
        map("n", "<leader>gr", gs.reset_hunk)
        map("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        map("n", "<leader>gp", gs.preview_hunk)
      end,
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
    "echasnovski/mini.surround",
    lazy = true,
    keys = {
      { "sa", mode = { "n", "x" } },
      { "sd" },
      { "sr" },
      { "sf" },
      { "sF" },
      { "sh" },
      { "sn" },
    },
    config = true,
  },
  {
    "j-hui/fidget.nvim",
    lazy = false,
    config = true,
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { mode = { "n", "o", "x" }, "w",  "<cmd>lua require('spider').motion('w')<CR>",  desc = "Spider-w" },
      { mode = { "n", "o", "x" }, "e",  "<cmd>lua require('spider').motion('e')<CR>",  desc = "Spider-e" },
      { mode = { "n", "o", "x" }, "b",  "<cmd>lua require('spider').motion('b')<CR>",  desc = "Spider-b" },
      { mode = { "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider-ge" },
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
  {
    "echasnovski/mini.icons",
    lazy = true,
    config = true,
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
            add_padding = true,
          },
        },
      })
    end,
    dependencies = { "echasnovski/mini.icons" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    ft = { "markdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
