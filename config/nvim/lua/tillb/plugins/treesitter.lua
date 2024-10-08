return {
  {
    "danymat/neogen",
    enabled = not (vim.g.basic or vim.env.NVIM_BASIC),
    cmd = "Neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },
  {
    "nvim-treesitter/playground",
    enabled = not (vim.g.basic or vim.env.NVIM_BASIC),
    cmd = "TSPlayground",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = not (vim.g.basic or vim.env.NVIM_BASIC),
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = not (vim.g.basic or vim.env.NVIM_BASIC),
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
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        -- ensure_installed = "all",
        sync_install = true,
        auto_install = true,
        indent = {
          enable = true,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        playground = {
          enable = not (vim.g.basic or vim.env.NVIM_BASIC),
        },

        textobjects = {
          enable = not (vim.g.basic or vim.env.NVIM_BASIC),
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
            -- selection_modes = {
            --   ["@parameter.outer"] = "v",
            --   ["@function.outer"] = "V",
            --   ["@class.outer"] = "V",
            -- },
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
        matchup = {
          enable = true,
        },
      })
    end,
  },
}
