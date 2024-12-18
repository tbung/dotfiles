return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000,
  config = function()
    local options = {
      flavour = "auto", -- latte, frappe, macchiato, mocha
      background = {    -- :h background
        light = "latte",
        dark = "mocha",
      },

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
        dap = {
          enabled = true,
          enable_ui = true,
        },
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        native_lsp = {
				underlines = {  -- TODO: Do we then need to change this in the LSP setup?
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
  end,
}
