vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

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
      Pmenu = { fg = colors.overlay2, bg = colors.base },
      PmenuMatch = { fg = colors.text, bg = colors.base },
      PmenuSel = { fg = colors.overlay2, bg = colors.surface1 },
      LspSignatureActiveParameter = { bold = true, bg = colors.surface1 },
      PmenuMatchSel = { fg = colors.text, bg = colors.surface1 },
      WinBar = { style = { "bold" } },
      StatusLineSecondary = { link = "StatusLineNC" },

      MsgBorder = { link = "MsgSeparator" },
      MiniPickBorder = { link = "MsgSeparator" },
      MiniPickBorderText = { link = "MsgArea" },
      MiniPickNormal = { link = "MsgArea" },
      MiniPickPrompt = { link = "MsgArea" },
      MiniPickPromptCaret = { link = "MsgArea" },
      MiniPickPromptPrefix = { link = "MsgArea" },

      -- NOTE: without this, light-mode makes the cursor hard to see
      TermCursor = { bg = colors.none },
      TermCursorNC = { bg = colors.none },
    }
  end,

  integrations = { gitsigns = true, mini = true },
})

vim.cmd.runtime("colors/catppuccin.vim")
