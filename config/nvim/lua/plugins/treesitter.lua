local ft_to_lang = require("nvim-treesitter.parsers").ft_to_lang
require("nvim-treesitter.parsers").ft_to_lang = function(ft)
  if ft == "zsh" then
    return "bash"
  else
    return ft_to_lang(ft)
  end
end

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  playground = {
    enable = true,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown", "latex" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  -- indent = {
  --   enable = true,
  -- },
  yati = { enable = true },
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
        ["<leader>p"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>P"] = "@parameter.inner",
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
