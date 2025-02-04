return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = "TSUpdate",
    config = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.markdown = {
        install_info = {
          -- url = "https://github.com/MDeiml/tree-sitter-markdown",
          url = "https://github.com/tbung/tree-sitter-markdown",
          location = "tree-sitter-markdown",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "fix-link-destination-with-tags",
        },
        maintainers = { "@MDeiml" },
        readme_name = "markdown (basic highlighting)",
        experimental = true,
      }

      parser_config.markdown_inline = {
        install_info = {
          -- url = "https://github.com/MDeiml/tree-sitter-markdown",
          url = "https://github.com/tbung/tree-sitter-markdown",
          location = "tree-sitter-markdown-inline",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "fix-link-destination-with-tags",
        },
        maintainers = { "@MDeiml" },
        readme_name = "markdown_inline (needed for full highlighting)",
        experimental = true,
      }

      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "c", "vim", "bash", "python" },
        sync_install = true,
        auto_install = true,
        indent = {
          enable = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
            },
            include_surrounding_whitespace = false,
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
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
}
