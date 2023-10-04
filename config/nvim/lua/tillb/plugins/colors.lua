return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha

      custom_highlights = function(colors)
        return {
          Folded = { bg = colors.mantle },
          WinBar = { style = { "bold" } },
        }
      end,

      integrations = {
        cmp = true,
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
      },
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
