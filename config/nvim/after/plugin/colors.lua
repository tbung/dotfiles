require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  integrations = {
    cmp = true,
    gitsigns = true,
    neotree = true,
    telescope = true,
    mini = true,
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
