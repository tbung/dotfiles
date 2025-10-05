vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
})

require("catppuccin").setup({
  float = { transparent = true },

  lsp_styles = {
    underlines = {
      errors = { "undercurl" },
      hints = { "undercurl" },
      warnings = { "undercurl" },
      information = { "undercurl" },
      ok = { "undercurl" },
    },
  },

  custom_highlights = function(colors)
    return {
      Folded = { bg = colors.mantle },
      Normal = { bg = colors.none },
      NormalNC = { bg = colors.none },
      Pmenu = { fg = colors.overlay2, bg = colors.surface0 },
      PmenuMatch = { fg = colors.text, bg = colors.surface0 },
      PmenuSel = { fg = colors.overlay2, bg = colors.surface1 },
      PmenuMatchSel = { fg = colors.text, bg = colors.surface1 },
      WinBar = { style = { "bold" } },
      MiniPickBorder = { link = "MsgBorder" },
      MiniPickBorderText = { link = "Normal" },

      -- NOTE: without this, light-mode makes the cursor hard to see
      TermCursor = { bg = colors.none },
      TermCursorNC = { bg = colors.none },
    }
  end,

  integrations = {
    gitsigns = true,
    mini = true,
  },
})

vim.cmd.runtime("colors/catppuccin.vim")
