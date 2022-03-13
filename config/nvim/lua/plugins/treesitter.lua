local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

require("nvim-treesitter.configs").setup({
  ensure_installed = "maintained",
  playground = {
    enable = true,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" }
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
  textsubjects = {
    enable = true,
    keymaps = {
      ["."] = "textsubjects-smart",
      [";"] = "textsubjects-container-outer",
    },
  },
  rainbow = {
    enable = false,
    extended_mode = false, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than 1000 lines, int
  },
})
