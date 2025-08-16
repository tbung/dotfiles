vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

local options = {
  flavour = "auto",
  background = { light = "latte", dark = "mocha" },
  float = { transparent = true, },

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
    telescope = true,
    mini = true,
    markdown = true,
    dap = { enabled = true, enable_ui = true },
    indent_blankline = { enabled = true, colored_indent_levels = false },
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
}

require("catppuccin").setup(options)
vim.cmd.colorscheme("catppuccin")
