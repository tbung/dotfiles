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
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
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
        map("n", "<leader>gS", gs.stage_buffer)
        map("n", "<leader>gu", gs.undo_stage_hunk)
        map("n", "<leader>gR", gs.reset_buffer)
        map("n", "<leader>gp", gs.preview_hunk)
        map("n", "<leader>gb", function()
          gs.blame_line({ full = true })
        end)
        map("n", "<leader>gd", gs.diffthis)
        map("n", "<leader>gD", function()
          gs.diffthis("~")
        end)

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
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
    "echasnovski/mini.sessions",
    event = "VimEnter",
    config = true,
  },
  {
    "echasnovski/mini.align",
    lazy = true,
    keys = {
      { "ga", mode = { "n", "x" } },
      { "gA", mode = { "n", "x" } },
    },
    config = true,
  },
  {
    "echasnovski/mini.starter",
    event = "VimEnter",
    config = function()
      local starter = require("mini.starter")
      starter.setup({
        items = {
          starter.sections.recent_files(5, true, true),
          starter.sections.builtin_actions(),
          starter.sections.sessions(5, true),
        },
        silent = true,
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
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { mode = { "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", desc = "Spider-w" },
      { mode = { "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", desc = "Spider-e" },
      { mode = { "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", desc = "Spider-b" },
      { mode = { "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", desc = "Spider-ge" },
    },
  },
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
          { "size", highlight = "Special" },
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
