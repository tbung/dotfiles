vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",

  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },

  "https://github.com/tpope/vim-fugitive",
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/sindrets/diffview.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/j-hui/fidget.nvim",

  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/olimorris/codecompanion.nvim",
  "https://github.com/ravitemer/mcphub.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
}, { load = false })

local group = vim.api.nvim_create_augroup("tillb-pack", {})

vim.api.nvim_create_autocmd("UIEnter", {
  group = group,
  once = true,
  callback = function(args)
    vim.schedule(function()
      require("fidget").setup({})
      require("mini.surround").setup({})
      vim.cmd.packadd("vim-fugitive")
      vim.cmd.packadd("vim-eunuch")
      vim.cmd.packadd("gitsigns.nvim")
    end)
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = group,
  callback = function(args)
    require("nvim-treesitter").install({ vim.treesitter.language.get_lang(vim.bo.filetype) })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    require("treesitter-context").setup({ enable = true })
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  group = group,
  callback = function(args)
    local spec = args.data.spec

    if spec and spec.name == "nvim-treesitter" and args.data.kind == "update" then
      vim.notify("nvim-treesitter was updated, updating parsers", vim.log.levels.INFO)

      vim.schedule(function()
        require("nvim-treesitter").update()
      end)
    end
  end,
})

-- NOTE: these have to be loaded immediately to work properly
require("catppuccin").setup({
  float = { transparent = true },

  custom_highlights = function(colors)
    return {
      Folded = { bg = colors.mantle },
      Normal = { bg = "none" },
      NormalNC = { bg = "none" },
      Pmenu = { bg = colors.none },
      WinBar = { style = { "bold" } },
    }
  end,

  integrations = {
    blink_cmp = true,
    gitsigns = true,
    mini = true,
    markdown = true,
    snacks = { enabled = true },
    native_lsp = {
      underlines = {
        errors = { "undercurl" },
        hints = { "undercurl" },
        warnings = { "undercurl" },
        information = { "undercurl" },
        ok = { "undercurl" },
      },
    },
  },
})
vim.cmd.colorscheme("catppuccin")

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
    { "icon", add_padding = true },
  },
})

require("snacks").setup({
  bigfile = { enabled = false },
  indent = { enabled = true, scope = { enabled = false }, animate = { enabled = false } },
  input = {
    enabled = true,
    win = {
      keys = {
        i_ctrl_bs = { "<C-BS>", "delete_word", mode = "i", expr = true },
        i_ctrl_h = { "<c-h>", "delete_word", mode = "i", expr = true },
      },
      actions = { delete_word = function()
        return "<c-s-w>"
      end },
    },
  },
  picker = {
    enabled = true,
    win = {
      input = {
        keys = { ["<C-BS>"] = { "<c-s-w>", mode = "i", expr = true }, ["<c-h>"] = { "<c-s-w>", mode = "i", expr = true } },
      },
    },
  },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  words = { enabled = false },
  image = { enabled = false },
})
