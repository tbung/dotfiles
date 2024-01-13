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
    event = "VeryLazy",
    config = true,
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    config = true,
    opts = {
      options = {
        ignore_blank_line = true,
      },
    },
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
