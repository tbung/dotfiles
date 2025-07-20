return {
  { "folke/lazydev.nvim", ft = "lua", config = true },
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = { "microsoft/python-type-stubs" },
    init = function()
      local lsppath = vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig"
      vim.opt.rtp:prepend(lsppath)

      vim.lsp.enable("basedpyright")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("texlab")

      vim.diagnostic.config({
        virtual_text = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
      })
    end,
  },
  { "mason-org/mason.nvim", lazy = false, config = true },
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "v1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- experimental signature help support
      signature = { enabled = true },
      cmdline = { enabled = false },
    },
  },
}
