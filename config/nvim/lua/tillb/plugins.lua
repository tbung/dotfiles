local execute = vim.api.nvim_command
local fn = vim.fn

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.0",
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = "nvim-telescope/telescope.nvim",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "nvim-treesitter/playground",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,
  },

  "mbbill/undotree",
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      attach_to_untracked = true,
    },
  },
  -- "tpope/vim-repeat",
  "tpope/vim-eunuch",

  {
    "numToStr/Comment.nvim",
    config = true,
  },

  {
    "jinh0/eyeliner.nvim",
    opts = { highlight_on_key = true, dim = true },
  },

  {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },

      -- Snippets
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
    },
  },
  "jose-elias-alvarez/null-ls.nvim",
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },

  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "theHamsta/nvim-dap-virtual-text",
  "mfussenegger/nvim-dap-python",
  "nvim-telescope/telescope-dap.nvim",

  {
    "lukas-reineke/indent-blankline.nvim",
    config = true,
  },

  "hkupty/iron.nvim",

  "echasnovski/mini.nvim",

  "nvim-tree/nvim-web-devicons",

  {
    "vigoux/notifier.nvim",
    config = true,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
  },

  "ThePrimeagen/harpoon",

  {
    "folke/which-key.nvim",
    config = true,
  },

  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
  },

  "folke/neodev.nvim",

  {
    "mickael-menu/zk-nvim",
    name = "zk",
    config = true,
  },

  {
    "smjonas/inc-rename.nvim",
    config = true,
  },

  "chrisgrieser/nvim-spider",
  "sindrets/diffview.nvim",

  {
    "stevearc/oil.nvim",
    config = true,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
}

require("lazy").setup(plugins, { dev = { path = "~/Projects", fallback = true } })
